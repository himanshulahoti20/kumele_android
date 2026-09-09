// Validates the backend's fixed-fixture guarantees for /match/events.
// Set environment variable: KUMELE_API_BASE_URL=http://84.247.131.180:8080
// pointed at an environment where usr_match_qc and its fixture events exist.
// No auth token is required against this host; set
// KUMELE_MATCH_TEST_TOKEN if a future environment needs one.
// Skips (does not fail) when KUMELE_API_BASE_URL is not provided, since this
// is a live backend contract test, not a unit test.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

final _apiBaseUrl = Platform.environment['KUMELE_API_BASE_URL'] ?? '';
final _testToken = Platform.environment['KUMELE_MATCH_TEST_TOKEN'] ?? '';

const _excludedIds = [
  'evt_rejected',
  'evt_full',
  'evt_past',
  'evt_outside_radius',
  'evt_blocked',
  'evt_sponsored_low_trust',
];

Future<Map<String, dynamic>> _requestMatches() async {
  final base = _apiBaseUrl.endsWith('/')
      ? _apiBaseUrl.substring(0, _apiBaseUrl.length - 1)
      : _apiBaseUrl;
  final uri = Uri.parse('$base/match/events').replace(queryParameters: {
    'user_id': 'usr_match_qc',
    'lat': '26.495478',
    'lon': '88.235725',
    'radius_km': '20',
    'limit': '10',
  });

  final response = await http.get(
    uri,
    headers: {
      if (_testToken.isNotEmpty) 'Authorization': 'Bearer $_testToken',
      'Accept': 'application/json',
    },
  );

  expect(response.statusCode, 200);
  return jsonDecode(response.body) as Map<String, dynamic>;
}

void main() {
  test(
    'filters unsafe events and ranks valid events correctly',
    () async {
      final payload = await _requestMatches();
      final results = (payload['results'] as List).cast<Map<String, dynamic>>();

      expect(payload['user_id'], 'usr_match_qc');
      expect(results.length, lessThanOrEqualTo(10));

      // Known best valid event must rank first.
      expect(results.first['event_id'], 'evt_expected_best');

      final returnedIds = results.map((item) => item['event_id']).toList();

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
      final repeatedIds =
          (repeated['results'] as List).map((item) => item['event_id']).toList();
      expect(repeatedIds, returnedIds);
    },
    skip: _apiBaseUrl.isEmpty ? 'KUMELE_API_BASE_URL not provided' : false,
  );
}
