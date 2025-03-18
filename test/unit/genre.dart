//file path: test/unit/genre.dart

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
    final id = 'a592dfc6-b601-4347-a060-a78ffabe4a8e';
    test('$entity.get', () async {
      final response = await client.genres.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.genres.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
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
