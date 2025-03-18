//file path: lib/src/musicbrainz_api_client_base.dart

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
  MusicBrainzApiClient({bool isSilent = true})
    : _httpClient = MusicBrainzHttpClient(isSilent: isSilent) {
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
