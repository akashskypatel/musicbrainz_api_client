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

//file path: test/unit/cover_art.dart
// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  late final MusicBrainzApiClient client;
  final entity = 'coverArt';
  setUpAll(() async {
    client = MusicBrainzApiClient();
  });

  tearDownAll(() {
    client.close();
  });

  group('MusicBrainzApiClient.CoverArtTest', () {
    test('$entity.get', () async {
      final id = '76df3287-6cda-33eb-8e9a-044b5e15ffdd';
      final response = await client.coverArt.get(id, 'release');
      expect(response, isA<Map<String, dynamic>>());
      print(
        'Get $entity for release. Number of images: ${response['images'].length}',
      );
    });

    test('$entity.get', () async {
      final id = 'c31a5e2b-0bf8-32e0-8aeb-ef4ba9973932';
      final response = await client.coverArt.get(id, 'release-group');
      expect(response, isA<Map<String, dynamic>>());
      print(
        'Get $entity for release-group. Number of images: ${response['images'].length}',
      );
    });

    test('$entity.get', () async {
      final id = 'd5fc8cec-fd15-4748-8175-c1c89eab2f10';
      dynamic response;
      if (client.isSilent) {
        response = await client.coverArt.get(id, 'release-group');
        expect(response['error'], isNotNull);
        print(
          'Get $entity for release-group. Error: ${response['error']}',
        );
      } else {
        expect(() async {
          response = await client.coverArt.get(id, 'release-group');
          expect(response['error'], isNotNull);
          print(
            'Get $entity for release-group. Error: ${response['error']}',
          );
        }, throwsException);
      }
    });
  });
}
