//file path: test/unit/event.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'event';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.EventTest', () {
    final id = '9067dfc9-4bfe-4e2b-b2f2-88fb30dd5c46';
    test('$entity.get', () async {
      final response = await client.events.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });

    test('$entity.get positive', () async {
      final response = await client.events.get(id, inc: ['aliases']);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['aliases'], isNotNull);
      print('Fetch $entity details: ${response['aliases']}');
    });
    test('$entity.get negative fake inc', () async {
      final response = await client.events.get(id, inc: ['fake']);
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });

    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.events.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });

    test('$entity.Search', () async {
      final response = await client.events.search('life');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });

    test('$entity.Browse positive no include', () async {
      final relatedEntity = 'area';
      final response = await client.events.browse(
        relatedEntity,
        '74e50e58-5deb-4b99-93a2-decbb365c07f',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Browse $entity: ${response['${entity}-count']}');
    });
    test('$entity.Browse positive w/ include=aliases', () async {
      final relatedEntity = 'area';
      final response = await client.events.browse(
        relatedEntity,
        '74e50e58-5deb-4b99-93a2-decbb365c07f',
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
      final relatedEntity = 'area';
      final response = await client.events.browse(relatedEntity, 'fake-id');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative fake include=fake', () async {
      final relatedEntity = 'area';
      final response = await client.events.browse(
        relatedEntity,
        'f33958ac-4198-3ce8-a751-1c44d9b4063a',
        inc: ['fake'],
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative invalid related entity', () async {
      final relatedEntity = 'release';
      final response = await client.events.browse(
        relatedEntity,
        '9067dfc9-4bfe-4e2b-b2f2-88fb30dd5c46',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
  });
}
