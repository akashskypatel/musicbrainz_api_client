//file path: test/unit/artist_client_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'series';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.SeriesTest', () {
    test('$entity.get', () async {
      final id = '648cf4c3-0647-432f-a131-aee9300042a2';
      final response = await client.series.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });

    test('$entity.Search', () async {
      final response = await client.series.search('life');
      expect(response, isA<Map<String, dynamic>>());
      expect(response[entity], isA<List<dynamic>>());
      print('Search $entity: ${response[entity].length}');
    });
  });
}
