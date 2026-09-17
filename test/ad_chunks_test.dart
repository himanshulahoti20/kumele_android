import 'package:flutter_test/flutter_test.dart';
import 'package:kuemele/features/explore/presentation/notification/widgets/ad_carousel_rail.dart';
import 'package:kuemele/shared/models/ads.dart';

List<AdItem> _ads(int count) => List.generate(
      count,
      (i) => AdItem(
        id: 'ad_$i',
        campaignId: 'c',
        title: 'Ad $i',
        mediaType: 'image',
        destinationType: 'external_url',
        moderationStatus: '',
        createdAt: '',
      ),
    );

List<int> _sizes(int count) =>
    chunkAdsForRails(_ads(count)).map((c) => c.length).toList();

void main() {
  test('ad rails split matches iOS makeAdChunks: two rails max, 6 then rest',
      () {
    expect(_sizes(0), <int>[]);
    expect(_sizes(3), [3]);
    expect(_sizes(6), [6]);
    expect(_sizes(8), [6, 2]);
    expect(_sizes(10), [6, 4]);
    expect(_sizes(12), [6, 6]);
    expect(_sizes(15), [6, 6]);
  });

  test('second rail is the ads after the first six, in order', () {
    final chunks = chunkAdsForRails(_ads(10));
    expect(chunks[1].map((a) => a.id), ['ad_6', 'ad_7', 'ad_8', 'ad_9']);
  });
}
