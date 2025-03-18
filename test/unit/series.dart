//file path: test/unit/series.dart

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
    final id = '648cf4c3-0647-432f-a131-aee9300042a2';
    test('$entity.get', () async {
      final response = await client.series.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });

    test('$entity.get positive', () async {
      final response = await client.series.get(id, inc: ['aliases']);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['aliases'], isNotNull);
      print('Fetch $entity details: ${response['aliases']}');
    });
    test('$entity.get negative fake inc', () async {
      final response = await client.series.get(id, inc: ['fake']);
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.series.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.Search', () async {
      final response = await client.series.search('life');
      expect(response, isA<Map<String, dynamic>>());
      expect(response[entity], isA<List<dynamic>>());
      print('Search $entity: ${response[entity].length}');
    });

    test('$entity.Browse', () async {
      var future = client.series.browse('', '');
      expect(future, throwsA(isA<UnimplementedError>()));
    });
  });
}
