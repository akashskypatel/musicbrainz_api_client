import 'dart:convert';

import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';

/// A client for interacting with the MusicBrainz API's ReleaseGroup-related endpoints.
///
/// This class provides methods to retrieve and search for ReleaseGroups (e.g., countries, cities)
/// in the MusicBrainz database.
///
/// **Related Entities**:
/// - `artist`, `collection`, `release`
///
/// **Subquery includes**
/// - `artists`, `releases`
///
/// **Browse includes**:
/// - `artist-credits`, `annotation`, `tags`, `genres`, `ratings`,
///
/// **Relationships**
/// - `artists`, `releases`
///
class ReleaseGroup {
  static const _client = 'MusicBrainzApi.ReleaseGroup';
  static final _logger = Logger(_client);
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'musicbrainz.org';
  final String _entity = 'release-group';
  final String _entities = 'release-groups';

  /// Creates a new instance of the [ReleaseGroup] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  ReleaseGroup(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;

  /// Retrieves detailed information about a specific ReleaseGroup by its MusicBrainz ID.
  ///
  /// - [id]: The MusicBrainz ID of the ReleaseGroup to retrieve.
  /// - [inc]: Additional details to include: `'artists'`,`'releases'`,`'artist-credits'`,
  /// `'annotation'`,`'tags'`,`'genres'`,`'ratings'`,`'artist-rels'`,`'release-rels'`, `'url-rels'`
  ///
  /// Returns a [Future] that completes with a [Map] containing the ReleaseGroup's details.
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
    return jsonDecode(response.body);
  }

  /// Searches for ReleaseGroups in the MusicBrainz database based on a query.
  ///
  /// - [query]: The search query to match against ReleaseGroup names, aliases, etc.
  /// - [limit]: The maximum number of results to return (default is 25).
  /// - [offset]: The offset for paginated results (default is 0).
  /// - [paginated]: Whether to return paginated results (default is `true`).
  ///
  /// Returns a [Future] that completes with the search results.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> search(
    String query, {
    int limit = 25,
    int offset = 0,
    bool paginated = true,
  }) async {
    return await _httpClient.searchEntity(
      _baseUrl,
      _entity,
      _entities,
      query,
      limit: limit,
      offset: offset,
      paginated: paginated,
    );
  }

  /// Browse areas by related entity in the MusicBrainz database based on related id.
  ///
  /// - [relatedEntity]: Entity realted to area to browse by: `'artist'`, `'release'`
  /// - [relatedId]: Id of the related entity to browse by.
  /// - [inc]: Additional details to include: `'annotation'`, `'tags'`, `'genres'`, `'ratings'`, `'artist-credits'`
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
