//file path: lib/src/clients/MusicBrainz_http_client.dart
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

enum HttpRequestType { GET, POST, PUT, DELETE }

/// Creates a new instance of [HttpRequestData].
///
/// - [method]: The HTTP method to use (e.g., GET, POST).
/// - [uri]: The URI to which the request will be sent.
/// - [validate]: Whether to validate the response (default is `false`).
/// - [headers]: The headers to include in the request (default includes 'accept': 'application/json').
/// - [body]: The body of the request (optional).
/// - [encoding]: The encoding to use for the request body (optional).
class HttpRequestData {
  HttpRequestType method = HttpRequestType.GET;
  Uri uri;
  bool validate;
  Map<String, String> headers;
  Object? body;
  Encoding? encoding;
  HttpRequestData(
    this.method,
    this.uri, {
    this.validate = false,
    this.headers = const {'accept': 'application/json'},
    this.body,
    this.encoding,
  });
}

/// A custom HTTP client for interacting with the MusicBrainz API.
///
/// This client handles rate limiting, request validation, and logging.
/// It extends [http.BaseClient] to provide additional functionality.
class MusicBrainzHttpClient extends http.BaseClient {
  static const _client = 'MusicBrainzApi.MusicBrainzHttpClient';
  late final Map<HttpRequestType, Function> _httpRequestHandlers;
  static final _logger = Logger(_client);
  final http.Client _httpClient;
  bool isSilent = true;

  /// Indicates whether the client has been closed.
  bool _closed = false;

  bool get closed => _closed;

  // Rate limit tracking
  int _requestCount = 0;
  int _rateLimit = 1; // Default limit
  int _rateLimitRemaining = 1; // Default remaining requests
  DateTime _rateLimitReset =
      DateTime.now(); // Timestamp when the rate limit resets
  DateTime _lastRequestTime = DateTime.now();

  static const Map<String, String> _defaultHeaders = {
    'user-agent':
        'Dart:MusicBrainz_API_Client/0.0.1 (https://github.com/akashskypatel/musicbrainz_api_client)',
  };

  /// Creates a new instance of [MusicBrainzHttpClient].
  ///
  /// Initializes the HTTP client and sets up request handlers for different HTTP methods.
  MusicBrainzHttpClient({this.isSilent = true}) : _httpClient = http.Client() {
    _httpRequestHandlers = {
      HttpRequestType.GET: (HttpRequestData reqData) async {
        Map<String, String> newHeaders = {};
        newHeaders.addAll(_defaultHeaders);
        newHeaders.addAll(reqData.headers);
        _lastRequestTime = DateTime.now();
        return await http.get(reqData.uri, headers: newHeaders);
      },
      HttpRequestType.POST: (HttpRequestData reqData) async {
        Map<String, String> newHeaders = {};
        newHeaders.addAll(_defaultHeaders);
        newHeaders.addAll(reqData.headers);
        _lastRequestTime = DateTime.now();
        return await http.post(
          reqData.uri,
          headers: newHeaders,
          body: reqData.body,
          encoding: reqData.encoding,
        );
      },
      HttpRequestType.PUT: (HttpRequestData reqData) async {
        Map<String, String> newHeaders = {};
        newHeaders.addAll(_defaultHeaders);
        newHeaders.addAll(reqData.headers);
        _lastRequestTime = DateTime.now();
        return await http.put(
          reqData.uri,
          headers: newHeaders,
          body: reqData.body,
          encoding: reqData.encoding,
        );
      },
      HttpRequestType.DELETE: (HttpRequestData reqData) async {
        Map<String, String> newHeaders = {};
        newHeaders.addAll(_defaultHeaders);
        newHeaders.addAll(reqData.headers);
        _lastRequestTime = DateTime.now();
        return await http.delete(
          reqData.uri,
          headers: newHeaders,
          body: reqData.body,
          encoding: reqData.encoding,
        );
      },
    };
  }

  /// Parses the rate limit headers from the HTTP response.
  ///
  /// Updates the rate limit, used requests, and remaining requests based on the headers.
  void _parseRateLimitHeaders(http.Response response) {
    var rateLimit = response.headers['x-ratelimit-limit'];
    var rateLimitRemaining = response.headers['x-ratelimit-remaining'];
    var rateLimitReset = response.headers['x-ratelimit-reset'];

    if (rateLimit != null) _rateLimit = int.parse(rateLimit);
    if (rateLimitRemaining != null) {
      _rateLimitRemaining = int.parse(rateLimitRemaining);
    }
    if (rateLimitReset != null) {
      _rateLimitReset = DateTime.fromMillisecondsSinceEpoch(
        int.parse(rateLimitReset) * 1000,
      );
    }

    _logger.warning(
      'Rate Limit: $_rateLimit, Used: ${_rateLimit - _rateLimitRemaining}, Reset: $_rateLimitReset',
    );
  }

  /// Sends an HTTP request based on the provided [HttpRequestData].
  ///
  /// - [reqData]: The data required to make the request.
  ///
  /// Returns a [Future] that completes with the [http.Response].
  ///
  /// Throws an [Exception] if the rate limit is exceeded or if the request fails.
  Future<http.Response> request(HttpRequestData reqData) async {
    try {
      // Check if the rate limit has been reset
      if (DateTime.now().isAfter(_rateLimitReset)) {
        _rateLimitRemaining = _rateLimit; // Reset remaining requests
      }

      // If no remaining requests, wait until the reset time
      if (_rateLimitRemaining <= 0) {
        await Future.delayed(Duration(seconds: 1));
        _rateLimitRemaining = _rateLimit; // Reset after waiting
      }

      // Make the request
      final response = await _request(reqData);

      return response;
    } catch (e, stackTrace) {
      _logger.warning(e);
      _logger.warning('Error');
      if (!isSilent) {
        throw Exception(stackTrace);
      }
      return http.Response('$e \n $stackTrace', 400);
    }
  }

  /// Internal method to send an HTTP request.
  ///
  /// - [reqData]: The data required to make the request.
  ///
  /// Returns a [Future] that completes with the [http.Response].
  ///
  /// Throws an [Exception] if the client is closed or if the request fails.
  Future<http.Response> _request(HttpRequestData reqData) async {
    late final http.Response response;
    try {
      Function req = _httpRequestHandlers[reqData.method]!;

      if (_closed) {
        if (!isSilent) {
          throw Exception('Client closed before request could be made.');
        }
        return http.Response('Client closed.', 400);
      }

      response = await req(reqData);
      _requestCount++;
      // Update rate limit headers
      _parseRateLimitHeaders(response);

      if (response.statusCode == 503) {
        _logger.warning('url:                  ${reqData.uri}');
        _logger.warning('requests-made:        $_requestCount');
        _logger.warning('now:                  ${DateTime.now().toString()}');
        _logger.warning('last request time:    $_lastRequestTime');
        _logger.warning('x-ratelimit-limit:    $_rateLimit');
        _logger.warning('x-ratelimit-remaining:$_rateLimitRemaining');
        _logger.warning('x-ratelimit-reset:    $_rateLimitReset');
        _logger.warning('Rate limit exceeded');
        await Future.delayed(Duration(seconds: 1));
        return await _request(reqData);
      }
      if (reqData.validate) {
        _validateResponse(response, response.statusCode);
      }
      return response;
    } catch (e, stackTrace) {
      _logger.warning(e);
      if (!isSilent) throw Exception(stackTrace);
      return http.Response('$e \n $stackTrace', 400);
    }
  }

  /// Searches for an entity in the MusicBrainz API.
  ///
  /// - [baseUrl]: The base URL of the MusicBrainz API.
  /// - [entity]: The type of entity to search for (e.g., 'artist', 'release').
  /// - [entities]: The plural form of the entity (e.g., 'artists', 'releases').
  /// - [query]: The search query.
  /// - [limit]: The maximum number of results to return (default is 25).
  /// - [offset]: The offset for paginated results (default is 0).
  /// - [paginated]: Whether to return paginated results (default is `true`).
  ///
  /// Returns a [Future] that completes with the search results.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> searchEntity(
    String baseUrl,
    String entity,
    String entities,
    String query, {
    int limit = 25,
    int offset = 0,
    bool paginated = true,
  }) async {
    try {
      final uri = Uri.https(baseUrl, 'ws/2/$entity', {
        'query': query,
        if (!paginated)
          'limit': (100).toString()
        else if (paginated)
          'limit': limit.toString(),
        'offset': offset.toString(),
      });

      final response = await request(HttpRequestData(HttpRequestType.GET, uri));

      // Handle non-200 status codes
      if (response.statusCode != 200) {
        if (!isSilent) {
          throw Exception(
            'Failed to load search results: ${response.statusCode}',
          );
        }
        return jsonDecode(response.body);
      }

      // Handle JSON format response
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['${entity}s'] ?? [];
      if (!paginated) {
        result.addAll(
          unpaginate(
            entity,
            entities,
            HttpRequestData(HttpRequestType.GET, uri),
            jsonResponse,
          ),
        );
        return result;
      }

      return jsonResponse;
    } catch (e, stackTrace) {
      _logger.warning(e);
      if (!isSilent) throw Exception(stackTrace);
      return http.Response('$e \n $stackTrace', 400);
    }
  }

  /// Browse for an entity in the MusicBrainz API.
  ///
  /// - [baseUrl]: The base URL of the MusicBrainz API.
  /// - [entity]: The type of entity to browse for (e.g., 'artist', 'release').
  /// - [relatedEntity]: Related entity to browse the browsing entity by.
  /// - [relatedId]: Id of the related entity to browse the browsing entity by.
  /// - [inc]: Fields to ionclude in the result.
  /// - [limit]: The maximum number of results to return (default is 25).
  /// - [offset]: The offset for paginated results (default is 0).
  /// - [paginated]: Whether to return paginated results (default is `true`).
  ///
  /// Returns a [Future] that completes with the search results.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> browseEntity(
    String baseUrl,
    String entity,
    String entities,
    String relatedEntity,
    String relatedId, {
    List<String>? inc,
    int limit = 25,
    int offset = 0,
    bool paginated = true,
  }) async {
    try {
      final uri = Uri.https(baseUrl, 'ws/2/$entity', {
        relatedEntity: relatedId,
        if (inc != null) 'inc': inc.join('+'),
        if (!paginated)
          'limit': (100).toString()
        else if (paginated)
          'limit': limit.toString(),
        'offset': offset.toString(),
      });

      final response = await request(HttpRequestData(HttpRequestType.GET, uri));

      // Handle non-200 status codes
      if (response.statusCode != 200) {
        if (!isSilent) {
          throw Exception(
            'Failed to load search results: ${response.statusCode}',
          );
        }
        return jsonDecode(response.body);
      }

      // Handle JSON format response
      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['${entity}s'] ?? [];
      if (!paginated) {
        result.addAll(
          unpaginate(
            entity,
            entities,
            HttpRequestData(HttpRequestType.GET, uri),
            jsonResponse,
          ),
        );
        return result;
      }

      return jsonResponse;
    } catch (e, stackTrace) {
      _logger.warning(e);
      if (!isSilent) throw Exception(stackTrace);
      return http.Response('$e \n $stackTrace', 400);
    }
  }

  /// Fetches all results for a paginated entity by making multiple requests.
  ///
  /// - [entity]: The type of entity to fetch (e.g., 'artist', 'release').
  /// - [entities]: The plural form of the entity (e.g., 'artists', 'releases').
  /// - [reqData]: The initial request data.
  /// - [jsonResponse]: The initial JSON response.
  ///
  /// Returns a [Future] that completes with the combined results.
  ///
  /// Throws an [Exception] if the request fails or if the response status code is not 200.
  Future<dynamic> unpaginate(
    String entity,
    String entities,
    HttpRequestData reqData,
    dynamic jsonResponse,
  ) async {
    final result = jsonResponse[entities] ?? [];
    try {
      final total = jsonResponse['$entity-count'];
      int offset = 0;
      for (var currentOffset = offset + result.length; currentOffset < total;) {
        final nextUri = reqData.uri.replace(
          queryParameters: {
            ...reqData.uri.queryParameters,
            'offset': currentOffset.toString(),
          },
        );
        final nextResponse = await request(
          HttpRequestData(HttpRequestType.GET, nextUri),
        );

        if (nextResponse.statusCode != 200) {
          if (!isSilent) {
            throw Exception(
              'Failed to load paginated results: ${nextResponse.statusCode}',
            );
          }
          return nextResponse;
        }

        final nextJsonResponse = jsonDecode(nextResponse.body);
        final nextResults = nextJsonResponse[entities] ?? [];

        if (nextResults == null) break;

        result.addAll(nextResults);
        currentOffset += nextResults.length as int;
      }
    } catch (e, stackTrace) {
      _logger.warning(e);
      if (!isSilent) throw Exception(stackTrace);
      return http.Response('$e \n $stackTrace', 400);
    }
    return result;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_closed) {
      if (!isSilent) {
        throw Exception();
      }
      final emptyStream = Stream<List<int>>.empty();
      final response = http.StreamedResponse(
        emptyStream, // Empty stream for the body
        204, // HTTP status code: 204 No Content
        request: request, // Pass the original request
        headers: {'Content-Length': '0'}, // Optional headers
      );

      return response;
    }

    // Apply default headers if they are not already present
    _defaultHeaders.forEach((key, value) {
      if (request.headers[key] == null) {
        request.headers[key] = _defaultHeaders[key]!;
      }
    });

    _logger.fine('Sending request: $request', null, StackTrace.current);
    _logger.finer('Request headers: ${request.headers}');
    if (request is http.Request) {
      _logger.finer('Request body: ${request.body}');
    }
    return _httpClient.send(request);
  }

  @override
  void close() {
    _closed = true;
    _httpClient.close();
  }

  /// Validates the HTTP response and throws an exception if the status code indicates an error.
  ///
  /// - [response]: The HTTP response to validate.
  /// - [statusCode]: The status code of the response.
  ///
  /// Throws an [Exception] if the status code is 4xx or 5xx.
  void _validateResponse(http.BaseResponse response, int statusCode) {
    if (_closed) return;

    if (statusCode >= 500) {
      if (!isSilent) throw Exception(response);
      return;
    }

    if (statusCode == 429) {
      if (!isSilent) throw Exception(response);
      return;
    }

    if (statusCode >= 400) {
      if (!isSilent) throw Exception(response);
      return;
    }
  }
}
