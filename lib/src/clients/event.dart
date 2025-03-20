import 'dart:convert';

import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';

/// A client for interacting with the MusicBrainz API's Event-related endpoints.
///
/// This class provides methods to retrieve and search for Events (e.g., countries, cities)
/// in the MusicBrainz database.
///
/// **Related Entities**:
/// - `area`, `artist`, `collection`, `place`
/// 
/// **Subquery includes**
/// - `'aliases'`, `'annotation'`, `'tags'`, `'genres'`, `'ratings'`, `'url-rels'`
///
/// **Browse includes**:
/// - `aliases`, `annotation`, `tags`, `genres`, `ratings`
///
class Event {
  static const _client = 'MusicBrainzApi.Event';
  static final _logger = Logger(_client);
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'musicbrainz.org';
  final String _entity = 'event';
  final String _entities = 'events';

  /// Creates a new instance of the [Event] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  Event(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;

  /// Retrieves detailed information about a specific Event by its MusicBrainz ID.
  ///
  /// - [id]: The MusicBrainz ID of the Event to retrieve.
  /// - [inc]: Additional details to include: `'aliases'`, `'annotation'`, `'tags'`, `'genres'`, `'ratings'`, `'url-rels'`
  ///
  /// Returns a [Future] that completes with a [Map] containing the Event's details.
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

  /// Searches for Events in the MusicBrainz database based on a query.
  ///
  /// - [query]: The search query to match against Event names, aliases, etc.
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
  /// - [relatedEntity]: Entity realted to area to browse by: `'area'`, `'artist'`, `'place'`
  /// - [relatedId]: Id of the related entity to browse by.
  /// - [inc]: Additional details to include: `'aliases'`, `'annotation'`, `'tags'`, `'genres'`, `'ratings'`
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
