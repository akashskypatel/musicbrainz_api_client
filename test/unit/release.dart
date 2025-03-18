//file path: test/unit/release.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'release';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.ReleaseTest', () {
    final id = '58074e34-88a6-47d3-bddd-4307697ef171';
    test('$entity.get', () async {
      final response = await client.releases.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });

    test('$entity.get positive', () async {
      final response = await client.releases.get(id, inc: ['aliases']);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['aliases'], isNotNull);
      print('Fetch $entity details: ${response['aliases']}');
    });
    test('$entity.get negative fake inc', () async {
      final response = await client.releases.get(id, inc: ['fake']);
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.releases.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.Search', () async {
      final response = await client.releases.search('life');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });

    test('$entity.Browse positive no include', () async {
      final relatedEntity = 'artist';
      final response = await client.releases.browse(
        relatedEntity,
        '606bf117-494f-4864-891f-09d63ff6aa4b',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Browse $entity: ${response['${entity}-count']}');
    });
    test('$entity.Browse positive w/ include=aliases', () async {
      final relatedEntity = 'artist';
      final response = await client.releases.browse(
        relatedEntity,
        '606bf117-494f-4864-891f-09d63ff6aa4b',
        inc: ['aliases'],
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      expect(response['${entity}s'][0]['aliases'], isA<List<dynamic>>());
      print(
        'Browse $entity w/ aliases: ${response['${entity}s'][0]['aliases']}',
      );
    });
    test('$entity.Browse negative fake-id no include', () async {
      final relatedEntity = 'artist';
      final response = await client.releases.browse(relatedEntity, 'fake-id');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative fake include=fake', () async {
      final relatedEntity = 'artist';
      final response = await client.releases.browse(
        relatedEntity,
        '606bf117-494f-4864-891f-09d63ff6aa4b',
        inc: ['fake'],
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative invalid related entity', () async {
      final relatedEntity = 'event';
      final response = await client.releases.browse(
        relatedEntity,
        '9067dfc9-4bfe-4e2b-b2f2-88fb30dd5c46',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
  });
}
