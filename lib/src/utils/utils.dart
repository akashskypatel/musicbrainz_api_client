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

import 'dart:convert';

import 'package:http/http.dart' as http;

/// Decodes an HTTP response based on the charset in the Content-Type header.
/// Falls back to UTF-8 if no charset is specified or unsupported.
/// Throws [FormatException] if the response is not valid JSON.
dynamic decodeJsonResponse(http.Response response) {
  final contentType = response.headers['content-type'];
  Encoding encoding = utf8; // Default

  if (contentType != null) {
    final charsetMatch = RegExp(
      r'charset=([^\s;]+)',
      caseSensitive: false,
    ).firstMatch(contentType);
    if (charsetMatch != null) {
      final charset = charsetMatch.group(1)?.toLowerCase();
      encoding = Encoding.getByName(charset!) ?? utf8;
    }
  }

  final decodedString = encoding.decode(response.bodyBytes);

  return tryDecode(decodedString);
}

dynamic tryDecode(data) {
  try {
    return jsonDecode(data);
  } catch (e) {
    return {'error': e, 'data': data.toString()};
  }
}
