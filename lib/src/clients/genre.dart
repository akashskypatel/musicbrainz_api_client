import 'dart:convert';

import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';

/// A client for interacting with the MusicBrainz API's genre-related endpoints.
///
/// This class provides methods to retrieve and search for genres in the MusicBrainz database.
///
class Genre {
  static final _logger = Logger('MusicBrainzApi.Genre');
  final MusicBrainzHttpClient _httpClient;
  final String _baseUrl = 'musicbrainz.org';
  final String _entity = 'genre';
  final String _entities = 'genres';

  /// Creates a new instance of the [Genre] client.
  ///
  /// - [httpClient]: The [MusicBrainzHttpClient] used to make HTTP requests.
  Genre(MusicBrainzHttpClient httpClient) : _httpClient = httpClient;

  /// Retrieves information about a specific genre or a list of genres.
  ///
  /// - [id]: The MusicBrainz ID of the genre to retrieve. Use `all` to retrieve all genres. Limit auto set to 100 if not paginated and id is `all`.
  /// - [limit]: The maximum number of results to return (default is 25).
  /// - [offset]: The offset for paginated results (default is 0).
  /// - [textFormat]: Whether to return the results in text format (default is `false`). Text format only allowed for `all` get request.
  /// - [paginated]: Whether to return paginated results (default is `true`).
  ///
  /// Returns a [Future] that completes with either a [Map<String, dynamic>] containing
  /// the genre(s) information or a [List<String>] if [textFormat] is `true`.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> get(
    String id, {
    int limit = 25,
    int offset = 0,
    bool textFormat = false,
    bool paginated = true,
  }) async {
    try {
      var uri = Uri.https(_baseUrl, 'ws/2/$_entity/$id', {
        if (id == 'all' && !paginated)
          'limit': (100).toString()
        else if (id == 'all' && paginated)
          'limit': limit.toString(),
        if (!textFormat) 'offset': offset.toString(),
        if (id == 'all' && textFormat) 'fmt': 'txt',
      });
      var response = await _httpClient.request(
        HttpRequestData(HttpRequestType.GET, uri),
      );

      // Handle non-200 status codes
      if (response.statusCode != 200) {
        if (!_httpClient.isSilent) {
          throw Exception(
            'Failed to load search results: ${response.statusCode}',
          );
        }
        return jsonDecode(response.body);
      }

      // Handle text format response
      if (textFormat) {
        return response.body
            .split(RegExp(r'\r?\n'))
            .where((line) => line.isNotEmpty)
            .toList();
      }

      // Handle JSON format response
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['${_entity}s'] ?? [];
      if (!paginated) {
        result.addAll(
          _httpClient.unpaginate(
            _entity,
            _entities,
            HttpRequestData(HttpRequestType.GET, uri),
            jsonResponse,
          ),
        );
        return result;
      }

      return jsonResponse;
    } catch (e, stackTrace) {
      _logger.warning(e);
      if (!_httpClient.isSilent) throw Exception(stackTrace);
      return;
    }
  }

  /// Retrieves all genres in the MusicBrainz database.
  ///
  /// - [textFormat]: Whether to return the results in text format (default is `false`).
  ///
  /// Returns a [Future] that completes with either a [Map<String, dynamic>] containing
  /// all genres or a [List<String>] if [textFormat] is `true`.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> all({bool textFormat = false}) async {
    try {
      return await get('all', textFormat: textFormat);
    } catch (e, stackTrace) {
      _logger.warning(e);
      if (!_httpClient.isSilent) throw Exception(stackTrace);
      return;
    }
  }
}
