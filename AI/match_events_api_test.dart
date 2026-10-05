import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

const excludedIds = {'evt_rejected', 'evt_full', 'evt_past', 'evt_outside_radius', 'evt_blocked', 'evt_sponsored_low_trust'};

Future<Map<String, dynamic>> requestMatches() async {
  final base = Platform.environment['KUMELE_API_BASE_URL'];
  final token = Platform.environment['KUMELE_MATCH_TEST_TOKEN'];
  expect(base, isNotNull); expect(Uri.parse(base!).scheme, 'https'); expect(token, isNotEmpty);
  final uri = Uri.parse('${base.replaceFirst(RegExp(r'/$'), '')}/match/events').replace(queryParameters: {
    'user_id': 'usr_match_qc', 'lat': '52.52', 'lon': '13.405', 'radius_km': '20', 'limit': '10',
  });
  final client = HttpClient();
  final request = await client.getUrl(uri); request.headers.set('Authorization', 'Bearer $token'); request.headers.set('Accept', 'application/json');
  final response = await request.close(); expect(response.statusCode, 200);
  final payload = jsonDecode(await response.transform(utf8.decoder).join()) as Map<String, dynamic>;
  client.close(); return payload;
}

void main() {
  test('preserves backend rank and excludes unsafe events', () async {
    final payload = await requestMatches(); final results = payload['results'] as List<dynamic>;
    expect(payload['user_id'], 'usr_match_qc'); expect(results[0]['event_id'], 'evt_expected_best'); expect(results[1]['event_id'], 'evt_safe_second');
    final ids = results.map((item) => item['event_id']).toList();
    for (final id in excludedIds) expect(ids, isNot(contains(id)));
    for (final item in results) { expect(item['score'], inInclusiveRange(0, 1)); expect((item['reasons'] as List), isNotEmpty); }
    for (var i = 1; i < results.length; i++) expect(results[i - 1]['score'], greaterThanOrEqualTo(results[i]['score']));
    expect(((await requestMatches())['results'] as List).map((item) => item['event_id']).toList(), ids);
  });
}
