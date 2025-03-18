//file path: test/unit/cover_art.dart

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
  });
}
