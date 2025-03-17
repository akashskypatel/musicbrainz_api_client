//file path: test/unit/artist_client_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'genre';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.GenreTest', () {
    test('$entity.get', () async {
      final id = 'a592dfc6-b601-4347-a060-a78ffabe4a8e';
      final response = await client.genres.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });
    test('$entity.all', () async {
      final response = await client.genres.all();
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });
    test('$entity.all.text', () async {
      final response = await client.genres.all(textFormat: true);
      expect(response, isA<List<String>>());
      print('Search $entity: ${response.length}');
    });
  });
}
