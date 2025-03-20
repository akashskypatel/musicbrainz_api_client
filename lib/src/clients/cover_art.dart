import 'dart:convert';

import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:logging/logging.dart';

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
      return jsonDecode(response.body);
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
