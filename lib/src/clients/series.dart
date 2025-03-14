import 'dart:convert';

import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';
/// A client for interacting with the MusicBrainz API's Series-related endpoints.
///
/// This class provides methods to retrieve and search for Seriess (e.g., countries, cities)
/// in the MusicBrainz database.
class Series {
  static final _logger = Logger('MusicBrainzApi.Series');
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'musicbrainz.org';
  final String _entity = 'series';
  final String _entities = 'series';
  /// Creates a new instance of the [Series] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  Series(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;
  /// Retrieves detailed information about a specific Series by its MusicBrainz ID.
  ///
  /// - [id]: The MusicBrainz ID of the Series to retrieve.
  ///
  /// Returns a [Future] that completes with a [Map] containing the Series's details.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<Map<String, dynamic>> get(String id) async {
    final uri = Uri.https(_baseUrl, 'ws/2/$_entity/$id', {
      'inc': 'aliases+annotation+tags+genres',
    });
    final HttpRequestData req = HttpRequestData(HttpRequestType.GET, uri);
    final response = await _httpClient.request(req);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      _logger.warning(response);
      throw Exception('Failed to load search results: ${response.statusCode}');
    }
  }
  /// Searches for Seriess in the MusicBrainz database based on a query.
  ///
  /// - [query]: The search query to match against Series names, aliases, etc.
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
}
