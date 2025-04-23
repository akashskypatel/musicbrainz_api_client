
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Decodes an HTTP response based on the charset in the Content-Type header.
  /// Falls back to UTF-8 if no charset is specified or unsupported.
  /// Throws [FormatException] if the response is not valid JSON.
  dynamic decodeJsonResponse(http.Response response) {
    final contentType = response.headers['content-type'];
    Encoding encoding = utf8; // Default

    if (contentType != null) {
      final charsetMatch = RegExp(r'charset=([^\s;]+)', caseSensitive: false).firstMatch(contentType);
      if (charsetMatch != null) {
        final charset = charsetMatch.group(1)?.toLowerCase();
        encoding = Encoding.getByName(charset!) ?? utf8;
      }
    }

    final decodedString = encoding.decode(response.bodyBytes);
    return jsonDecode(decodedString);
  }