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

//file path: lib/src/musicbrainz_api_client_base.dart

import 'package:http/http.dart' as http;
import 'package:musicbrainz_api_client/src/clients/area.dart';
import 'package:musicbrainz_api_client/src/clients/artist.dart';
import 'package:musicbrainz_api_client/src/clients/event.dart';
import 'package:musicbrainz_api_client/src/clients/genre.dart';
import 'package:musicbrainz_api_client/src/clients/instrument.dart';
import 'package:musicbrainz_api_client/src/clients/label.dart';
import 'package:musicbrainz_api_client/src/clients/musicbrainz_http_client.dart';
import 'package:musicbrainz_api_client/src/clients/place.dart';
import 'package:musicbrainz_api_client/src/clients/recording.dart';
import 'package:musicbrainz_api_client/src/clients/release_group.dart';
import 'package:musicbrainz_api_client/src/clients/release.dart';
import 'package:musicbrainz_api_client/src/clients/series.dart';
import 'package:musicbrainz_api_client/src/clients/url.dart';
import 'package:musicbrainz_api_client/src/clients/work.dart';
import 'package:musicbrainz_api_client/src/clients/cover_art.dart';

class MusicBrainzApiClient {
  late final MusicBrainzHttpClient _httpClient;
  late final Area areas;
  late final Artist artists;
  late final Event events;
  late final Genre genres;
  late final Instrument instruments;
  late final Label labels;
  late final Place places;
  late final Recording recordings;
  late final ReleaseGroup releaseGroups;
  late final Release releases;
  late final Series series;
  late final URL urls;
  late final Work works;
  late final CoverArt coverArt;

  /// Creates a new instance of [MusicBrainzApiClient].
  ///
  /// This client provides access to various MusicBrainz API endpoints such as
  /// artists, releases, recordings, and more. Each endpoint is represented
  /// by a corresponding client (e.g., [Artist], [Release], [Recording]).
  ///
  /// Example usage:
  /// ```dart
  /// final client = MusicBrainzApiClient();
  /// final artist = await client.artists.get('artist-id');
  /// client.close();
  /// ```
  MusicBrainzApiClient({http.Client? httpClient, bool isSilent = true})
    : _httpClient = MusicBrainzHttpClient(httpClient, isSilent) {
    genres = Genre(_httpClient);
    areas = Area(_httpClient);
    artists = Artist(_httpClient);
    events = Event(_httpClient);
    instruments = Instrument(_httpClient);
    labels = Label(_httpClient);
    places = Place(_httpClient);
    recordings = Recording(_httpClient);
    releaseGroups = ReleaseGroup(_httpClient);
    releases = Release(_httpClient);
    series = Series(_httpClient);
    urls = URL(_httpClient);
    works = Work(_httpClient);
    coverArt = CoverArt(_httpClient);
  }

  /// Closes the underlying HTTP client and releases any resources.
  ///
  /// Call this method when the client is no longer needed to free up resources.
  /// After calling this method, the client should no longer be used.
  ///
  /// Example usage:
  /// ```dart
  /// final client = MusicBrainzApiClient();
  /// // Use the client...
  /// client.close();
  /// ```
  void close() => _httpClient.close();
}
