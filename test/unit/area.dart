//file path: test/unit/area.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'area';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.AreaTest', () {
    final id = 'f33958ac-4198-3ce8-a751-1c44d9b4063a';
    test('$entity.get', () async {
      final response = await client.areas.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });
    test('$entity.get positive', () async {
      final response = await client.areas.get(id, inc: ['aliases']);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['aliases'], isNotNull);
      print('Fetch $entity details: ${response['aliases'][0]}');
    });
    test('$entity.get negative fake inc', () async {
      final response = await client.areas.get(id, inc: ['fake']);
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.areas.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });

    test('$entity.Search', () async {
      final response = await client.areas.search('america');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });

    test('$entity.Browse', () async {
      var future = client.areas.browse('', '');
      expect(future, throwsA(isA<UnimplementedError>()));
    });
  });
}
