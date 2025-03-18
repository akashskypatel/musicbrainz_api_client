//file path: test/unit/url.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'url';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.URLTest', () {
    final id = '80993f06-1a84-49fc-9786-95cc281cd89f';
    test('$entity.get', () async {
      final response = await client.urls.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.urls.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.Search', () async {
      final response = await client.urls.search('life');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });

    test('$entity.Browse positive no include', () async {
      final relatedEntity = 'resource';
      final response = await client.urls.browse(
        relatedEntity,
        'https://www.discogs.com/master/1524311',
      );
      expect(response, isA<Map<String, dynamic>>());
      print('Browse $entity: $response');
    });
  });
}
