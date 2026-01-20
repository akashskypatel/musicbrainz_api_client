// MIT License

// Copyright (c) 2025 Akash Patel

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//file path: test/unit/place.dart
// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'place';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.PlaceTest', () {
    final id = '528c67be-56d8-4144-ba80-34363d41f35c';
    test('$entity.get', () async {
      final response = await client.places.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['id'], equals(id));
      print('Fetch $entity details: ${response['id']}');
    });

    test('$entity.get positive', () async {
      final response = await client.places.get(id, inc: ['aliases']);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['aliases'], isNotNull);
      print('Fetch $entity details: ${response['aliases']}');
    });
    test('$entity.get negative fake inc', () async {
      final response = await client.places.get(id, inc: ['fake']);
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.get negative fake id', () async {
      final id = 'fake-id';
      final response = await client.places.get(id);
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Fetch $entity details: $response');
    });
    test('$entity.Search', () async {
      final response = await client.places.search('washington');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });
    test('$entity.Search w/ params', () async {
      final response = await client.places.search(
        'washington',
        params: {'dismax': 'true'},
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Search $entity: ${response['${entity}s'].length}');
    });
    test('$entity.Browse positive no include', () async {
      final relatedEntity = 'area';
      final response = await client.places.browse(
        relatedEntity,
        '74e50e58-5deb-4b99-93a2-decbb365c07f',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['${entity}s'], isA<List<dynamic>>());
      print('Browse $entity: ${response['$entity-count']}');
    });
    test('$entity.Browse positive w/ include=aliases', () async {
      final relatedEntity = 'area';
      final response = await client.places.browse(
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
      final response = await client.places.browse(relatedEntity, 'fake-id');
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative fake include=fake', () async {
      final relatedEntity = 'area';
      final response = await client.places.browse(
        relatedEntity,
        'f33958ac-4198-3ce8-a751-1c44d9b4063a',
        inc: ['fake'],
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
    test('$entity.Browse negative invalid related entity', () async {
      final relatedEntity = 'recording';
      final response = await client.places.browse(
        relatedEntity,
        '9067dfc9-4bfe-4e2b-b2f2-88fb30dd5c46',
      );
      expect(response, isA<Map<String, dynamic>>());
      expect(response['error'], isNotNull);
      print('Browse $entity details: $response');
    });
  });
}
