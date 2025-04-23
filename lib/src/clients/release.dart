import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';
import 'package:musicbrainz_api_client/src/utils/utils.dart';

/// A client for interacting with the MusicBrainz API's Release-related endpoints.
///
/// This class provides methods to retrieve and search for Releases (e.g., countries, cities)
/// in the MusicBrainz database.
///
/// **Related Entities**:
/// - `area`, `artist`, `collection`, `label`, `track`, `track_artist`, `recording`, `release-group`
///
/// **Subquery includes**
/// - `artists`, `collections`, `labels`, `recordings`, `release-groups`
///
/// **Browse includes**:
/// - `artist-credits`, `labels`, `recordings`, `release-groups`, `media`, `discids`, `isrcs`,
///   `annotation`, `tags`, `genres`
///
/// **Relationships**
/// - `artists`, `collections`, `labels`, `recordings`, `release-groups`
///
class Release {
  static const _client = 'MusicBrainzApi.Release';
  static final _logger = Logger(_client);
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'musicbrainz.org';
  final String _entity = 'release';
  final String _entities = 'releases';

  /// Creates a new instance of the [Release] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  Release(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;

  /// Retrieves detailed information about a specific Release by its MusicBrainz ID.
  ///
  /// - [id]: The MusicBrainz ID of the Release to retrieve.
  /// - [inc]: Additional details to include: `'artists'`, `'collections'`, `'labels'`, `'recordings'`,
  ///   `'release-groups'`,`'artist-credits'`,`'media'`,`'discids'`,`'isrcs'`,`'annotation'`,`'tags'`,
  ///   `'genres'`,`'artist-rels'`,`'label-rels'`,`'recording-rels'`,`'release-group-rels'`, `'url-rels'`
  ///
  /// Returns a [Future] that completes with a [Map] containing the Release's details.
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

  /// Searches for Releases in the MusicBrainz database based on a query.
  /// 
  /// Accepts Apache Lucene search syntax:
  /// https://lucene.apache.org/core/7_7_2/queryparser/org/apache/lucene/queryparser/classic/package-summary.html#package.description
  /// 
  /// Additional information on query parameters can be found here: https://musicbrainz.org/doc/MusicBrainz_API/Search
  ///
  /// - [query]: The search query to match against Release names, aliases, etc.
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
  /// - [relatedEntity]: Entity realted to area to browse by: `'area'`, `'artist'`, `'label'`, `'track'`, `'track_artist'`, `'recording'`, `'release-group'`
  /// - [relatedId]: Id of the related entity to browse by.
  /// - [inc]: Additional details to include: `'annotation'`, `'tags'`, `'genres'`, `'artist-credits'`, `'labels'`, `'recordings'`, `'release-groups'`, `'media'`, `'discids'`, `'isrcs'`
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
