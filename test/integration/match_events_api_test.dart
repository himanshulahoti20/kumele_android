// Validates /match/events against Kumele's authenticated HTTPS gateway
// (not the direct AI/ML service — mobile clients must go through the
// gateway, so that is what this test exercises).
//
// Required env vars (all core tests skip, with a clear reason, if any are
// missing — this suite never silently passes on a misconfigured run):
//   KUMELE_API_BASE_URL      e.g. https://api.kumele.com/api/v1
//   KUMELE_MATCH_TEST_LAT    fixture user's fixed latitude, e.g. 52.5200
//   KUMELE_MATCH_TEST_LON    fixture user's fixed longitude, e.g. 13.4050
//   KUMELE_MATCH_TEST_TOKEN  a fresh, valid bearer token for usr_match_qc
// Optional:
//   KUMELE_MATCH_TEST_FOREIGN_TOKEN  a valid token for a DIFFERENT user,
//     used only by the cross-user-access test.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

final _apiBaseUrl = Platform.environment['KUMELE_API_BASE_URL'] ?? '';
final _lat = Platform.environment['KUMELE_MATCH_TEST_LAT'] ?? '';
final _lon = Platform.environment['KUMELE_MATCH_TEST_LON'] ?? '';
final _testToken = Platform.environment['KUMELE_MATCH_TEST_TOKEN'] ?? '';
final _foreignToken =
    Platform.environment['KUMELE_MATCH_TEST_FOREIGN_TOKEN'] ?? '';

const _userId = 'usr_match_qc';
const _expectedWinner = 'evt_expected_best';
const _expectedSecond = 'evt_safe_second';
const _excludedIds = [
  'evt_rejected',
  'evt_full',
  'evt_past',
  'evt_outside_radius',
  'evt_blocked',
  'evt_sponsored_low_trust',
];

bool get _hasLocationConfig =>
    _apiBaseUrl.isNotEmpty && _lat.isNotEmpty && _lon.isNotEmpty;

bool get _hasCoreConfig => _hasLocationConfig && _testToken.isNotEmpty;

const _locationConfigMissing =
    'KUMELE_API_BASE_URL / KUMELE_MATCH_TEST_LAT / KUMELE_MATCH_TEST_LON '
    'not provided';
const _coreConfigMissing = '$_locationConfigMissing / KUMELE_MATCH_TEST_TOKEN '
    'not provided';

String get _base => _apiBaseUrl.endsWith('/')
    ? _apiBaseUrl.substring(0, _apiBaseUrl.length - 1)
    : _apiBaseUrl;

Uri _matchEventsUri({String? lat, String? lon, String userId = _userId}) {
  final params = <String, String>{
    'user_id': userId,
    'radius_km': '20',
    'limit': '10',
    if (lat != null) 'lat': lat,
    if (lon != null) 'lon': lon,
  };
  return Uri.parse('$_base/match/events').replace(queryParameters: params);
}

Future<http.Response> _get(Uri uri, {String? token}) {
  return http.get(uri, headers: {
    'Accept': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  });
}

Future<Map<String, dynamic>> _requestMatches() async {
  final response =
      await _get(_matchEventsUri(lat: _lat, lon: _lon), token: _testToken);
  expect(
    response.statusCode,
    200,
    reason: 'Expected 200 from authenticated /match/events, got '
        '${response.statusCode}: ${response.body}',
  );
  return jsonDecode(response.body) as Map<String, dynamic>;
}

void main() {
  group('match/events (authenticated HTTPS gateway)', () {
    test(
      'filters unsafe events and ranks valid events correctly',
      () async {
        final payload = await _requestMatches();
        final results =
            (payload['results'] as List).cast<Map<String, dynamic>>();

        expect(payload['user_id'], _userId);
        expect(
          payload['fallback_used'],
          isFalse,
          reason: 'fallback_used=true means the ML ranking path did not '
              'run (only the degraded fallback did) — this is not a valid '
              'ranking result to assert against.',
        );
        expect(
          results,
          isNotEmpty,
          reason: 'No results for $_userId at ($_lat, $_lon). The backend '
              'fixture ($_userId plus evt_expected_best / evt_safe_second / '
              '...) has not been provisioned on this environment — this is '
              'a backend data gap, not a client bug.',
        );

        expect(results.length, lessThanOrEqualTo(10));
        expect(results.first['event_id'], _expectedWinner);

        final returnedIds = results.map((item) => item['event_id']).toList();

        expect(
          returnedIds,
          contains(_expectedSecond),
          reason: '$_expectedSecond must be present in the results',
        );
        expect(
          returnedIds.indexOf(_expectedSecond),
          greaterThan(returnedIds.indexOf(_expectedWinner)),
          reason: '$_expectedSecond must rank below $_expectedWinner',
        );

        for (final excludedId in _excludedIds) {
          expect(returnedIds, isNot(contains(excludedId)));
        }

        for (final item in results) {
          final score = (item['score'] as num).toDouble();
          expect(score, greaterThanOrEqualTo(0));
          expect(score, lessThanOrEqualTo(1));
          expect((item['reasons'] as List), isNotEmpty);
        }

        // Backend results must already be in descending order.
        for (var index = 1; index < results.length; index++) {
          final prevScore = (results[index - 1]['score'] as num).toDouble();
          final score = (results[index]['score'] as num).toDouble();
          expect(prevScore, greaterThanOrEqualTo(score));
        }

        // Fixed fixtures should return a stable order.
        final repeated = await _requestMatches();
        final repeatedIds = (repeated['results'] as List)
            .map((item) => item['event_id'])
            .toList();
        expect(repeatedIds, returnedIds);
      },
      skip: _hasCoreConfig ? false : _coreConfigMissing,
    );

    test(
      'missing coordinates return 422',
      () async {
        final response =
            await _get(_matchEventsUri(userId: _userId), token: _testToken);
        expect(response.statusCode, 422);
      },
      skip: (_apiBaseUrl.isNotEmpty && _testToken.isNotEmpty)
          ? false
          : 'KUMELE_API_BASE_URL / KUMELE_MATCH_TEST_TOKEN not provided',
    );

    test(
      'no token returns 401',
      () async {
        final response = await _get(_matchEventsUri(lat: _lat, lon: _lon));
        expect(response.statusCode, 401);
      },
      skip: _hasLocationConfig ? false : _locationConfigMissing,
    );

    test(
      // A genuinely *expired* token needs the backend to mint one — a
      // malformed token exercises the same auth-rejection path (invalid
      // signature/claims) and is what we can self-provision here.
      'malformed or invalid token returns 401',
      () async {
        final response = await _get(
          _matchEventsUri(lat: _lat, lon: _lon),
          token: 'not-a-real-token',
        );
        expect(response.statusCode, 401);
      },
      skip: _hasLocationConfig ? false : _locationConfigMissing,
    );

    test(
      'cross-user access returns 403',
      () async {
        final response = await _get(
          _matchEventsUri(lat: _lat, lon: _lon, userId: _userId),
          token: _foreignToken,
        );
        expect(response.statusCode, 403);
      },
      skip: (_hasLocationConfig && _foreignToken.isNotEmpty)
          ? false
          : 'KUMELE_MATCH_TEST_FOREIGN_TOKEN not provided (needs a valid '
              'token for a user other than $_userId)',
    );
  });
}
