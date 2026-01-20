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

import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';
import 'package:musicbrainz_api_client/src/utils/utils.dart';

/// A client for interacting with the MusicBrainz API's Artist-related endpoints.
///
/// This class provides methods to retrieve and search for Artists (e.g., countries, cities)
/// in the MusicBrainz database.
class CoverArt {
  static const _client = 'MusicBrainzApi.CoverArt';
  static final _logger = Logger(_client);
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'coverartarchive.org';
  final List<String> _validEntities = ['release', 'release-group'];

  /// Creates a new instance of the [CoverArt] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  CoverArt(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;

  /// Retrieves detailed information about a specific Artist by its MusicBrainz ID.
  ///
  /// - [id]: The MusicBrainz ID of the Artist to retrieve.
  /// - [entity]: Entioty to retreive artwork for. Either: `releases` or `release-groups`
  ///
  /// Returns a [Future] that completes with a [Map] containing the Artist's details.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> get(String id, String entity) async {
    if (!_validEntities.contains(entity)) {
      throw Exception('Invalid entity provided.');
    }
    final uri = Uri.https(_baseUrl, '$entity/$id');
    final HttpRequestData req = HttpRequestData(HttpRequestType.GET, uri);
    final response = await _httpClient.request(req);

    if (response.statusCode == 200) {
      return decodeJsonResponse(response);
    } else {
      _logger.warning(response);
      if (!_httpClient.isSilent) {
        throw Exception(
          '$_client: Failed to get results: ${response.statusCode}',
        );
      }
      return {'error': response.body.toString()};
    }
  }
}
