//file path: test/unit/release_group.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'release-group';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.ReleaseGroupTest', () {
    final id = '5ec4ddac-9323-4072-ab00-fd84a94a0e3a';
    test('$entity.get', () async {
      final response = await client.releaseGroups.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });

    test('$entity.get positive', () async {
      final response = await client.releaseGroups.get(id, inc: ['aliases']);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['aliases'], isNotNull);
      print('Fetch $entity details: ${response['aliases']}');
    });
    test('$entity.get negative fake inc', () async {
      final response = await client.releaseGroups.get(id, inc: ['fake']);
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.releaseGroups.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.Search', () async {
      final response = await client.releaseGroups.search('life');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });

    test('$entity.Browse positive no include', () async {
      final relatedEntity = 'artist';
      final response = await client.releaseGroups.browse(
        relatedEntity,
        '606bf117-494f-4864-891f-09d63ff6aa4b',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Browse $entity: ${response['${entity}-count']}');
    });
    test('$entity.Browse positive w/ include=aliases', () async {
      final relatedEntity = 'artist';
      final response = await client.releaseGroups.browse(
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
      final response = await client.releaseGroups.browse(
        relatedEntity,
        'fake-id',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative fake include=fake', () async {
      final relatedEntity = 'artist';
      final response = await client.releaseGroups.browse(
        relatedEntity,
        '606bf117-494f-4864-891f-09d63ff6aa4b',
        inc: ['fake'],
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative invalid related entity', () async {
      final relatedEntity = 'recording';
      final response = await client.releaseGroups.browse(
        relatedEntity,
        '9067dfc9-4bfe-4e2b-b2f2-88fb30dd5c46',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
  });
}
