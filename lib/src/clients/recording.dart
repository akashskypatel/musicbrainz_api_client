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

/// A client for interacting with the MusicBrainz API's Recording-related endpoints.
///
/// This class provides methods to retrieve and search for Recordings (e.g., countries, cities)
/// in the MusicBrainz database.
///
/// **Related Entities**:
/// - `artist`, `collection`, `release`, `work`
///
/// **Subquery includes**
/// - `artists`, `releases`, `release-groups`, `isrcs`, `url-rels`
///
/// **Browse includes**:
/// - `artist-credits`, `isrcs`, `annotation`, `tags`, `genres`, `ratings`
///
/// **Relationships**
/// - `artists`, `releases`, `release-groups`, `isrcs`, `url-rels`
///
class Recording {
  static const _client = 'MusicBrainzApi.Recording';
  static final _logger = Logger(_client);
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'musicbrainz.org';
  final String _entity = 'recording';
  final String _entities = 'recordings';

  /// Creates a new instance of the [Recording] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  Recording(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;

  /// Retrieves detailed information about a specific Recording by its MusicBrainz ID.
  ///
  /// - [id]: The MusicBrainz ID of the Recording to retrieve.
  /// - [inc]: Additional details to include: `'artists'`, `'releases'`, `'release-groups'`, `'isrcs'`,
  ///  `'url-rels'`, `'artist-credits'`, `'annotation'`,`'tags'`,`'genres'`,`'ratings'`,`'artist-rels'`,
  ///  `'release-rels'`,`'release-group-rels'`
  ///
  /// Returns a [Future] that completes with a [Map] containing the Recording's details.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> get(String id, {List<String> inc = const []}) async {
    final uri = Uri.https(_baseUrl, 'ws/2/$_entity/$id', {
      if (inc.isNotEmpty) 'inc': inc.join('+'),
    });
    final HttpRequestData req = HttpRequestData(HttpRequestType.GET, uri);
    final response = await _httpClient.request(req);

    if (response.statusCode != 200) {
      _logger.warning(
        '$_client: Failed to get results: ${response.statusCode}',
      );
      _logger.warning(response);
      if (!_httpClient.isSilent) {
        throw Exception(
          '$_client: Failed to get results: ${response.statusCode}',
        );
      }
    }
    return decodeJsonResponse(response);
  }

  /// Searches for Recordings in the MusicBrainz database based on a query.
  ///
  /// Accepts Apache Lucene search syntax:
  /// https://lucene.apache.org/core/7_7_2/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package.description
  ///
  /// Additional information on query parameters can be found here: https://musicbrainz.org/doc/MusicBrainz_API/Search
  ///
  /// - [query]: The search query to match against Recording names, aliases, etc.
  /// - [limit]: The maximum number of results to return (default is 25).
  /// - [offset]: The offset for paginated results (default is 0).
  /// - [paginated]: Whether to return paginated results (default is `true`).
  /// - [params]: Additional URL query parameters (see https://musicbrainz.org/doc/MusicBrainz_API/Search)
  ///
  /// Returns a [Future] that completes with the search results.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> search(
    String query, {
    int limit = 25,
    int offset = 0,
    bool paginated = true,
    Map<String, String>? params,
  }) async {
    return await _httpClient.searchEntity(
      _baseUrl,
      _entity,
      _entities,
      query,
      limit: limit,
      offset: offset,
      paginated: paginated,
      params: params,
    );
  }

  /// Browse areas by related entity in the MusicBrainz database based on related id.
  ///
  /// - [relatedEntity]: Entity realted to area to browse by: `'artist'`, `'release'`, `'work'`
  /// - [relatedId]: Id of the related entity to browse by.
  /// - [inc]: Additional details to include: `'annotation'`, `'tags'`, `'genres'`, `'ratings'`, `'artist-credits'`, `'isrcs'`
  /// - [limit]: The maximum number of results to return (default is 25).
  /// - [offset]: The offset for paginated results (default is 0).
  /// - [paginated]: Whether to return paginated results (default is `true`).
  ///
  /// Returns a [Future] that completes with the search results.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> browse(
    String relatedEntity,
    String relatedId, {
    List<String> inc = const [],
    int limit = 25,
    int offset = 0,
    bool paginated = true,
  }) async {
    return await _httpClient.browseEntity(
      _baseUrl,
      _entity,
      _entities,
      relatedEntity,
      relatedId,
      inc: inc,
      limit: limit,
      offset: offset,
      paginated: paginated,
    );
  }
}
