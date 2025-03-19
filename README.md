# MusicBrainz API Client

A Dart/Flutter client for interacting with the [MusicBrainz API](https://musicbrainz.org/doc/MusicBrainz_API). This package provides a simple and easy-to-use interface for accessing MusicBrainz' music database to retreive artist, event, genre, instrument, label, place, recording, release, release-group, series, work, and url data. This package does not provide any methods that requires user level authentication.

## Features

 - **Area** - Areas are historical and existing geographic regions. Areas include countries, sub-divisions, counties, municipalities, cities, districts and islands.
 - **Artist** - An artist is generally a musician, group of musicians, a collaboration of multiple musicians or other music professionals who contribute to works described in the MusicBrainz Database. They can also be a non-musical person (like a photographer, an illustrator, or a poet whose writings are set to music), or even a fictional character.
 - **Event** - An organised event which people can attend, and is relevant to MusicBrainz. Events generally refer to live performances, like concerts and festivals.
 - **Genre** - Genres are a way to categorize music based on its style or other common characteristic.
 - **Instrument** - Instruments are devices created or adapted to make musical sounds.
 - **Label** - Labels are generally imprints on releases, and to a lesser extent, the record companies behind those imprints.
 - **Place** - Places are areas smaller than a geographical region (like a building or an outdoor area) used to perform or produce music. It could range from a stadium to a religious building to an indoor arena.
 - **Recording** - Recordings are unique audio data. It has a title, artist credit, and length. Recordings can be linked to tracks on releases. Each track must always be associated with a single recording, but a recording can be linked to any number of tracks.
 - **Release** - Releases are real-world release objects (like a physical album) that you can buy in your music store. When a musical product is issued on a specific date with specific information such as the country, label, barcode and packaging, it is a release.
 - **Release-group** - Release groups are an abstract "album" entity. Technically it's a group of releases, with a specified type.
 - **Series** - A series is a sequence of separate release groups, releases, recordings, works or events with a common theme. The theme is usually prominent in the branding of the entities in the series and the individual entities will often have been given a number indicating the position in the series.
 - **Work** - A work is a distinct intellectual or artistic creation, which can be expressed in the form of one or more audio recordings. While a recording represents audio data, a work represents the composition behind the recording.
 - **Url** - A URL represents a regular Internet Uniform Resource Locator and an associated description of that URL.
 - **Cover Art** - Covert art for releases or release-groups.

## Installation

1. Download repository
2. Run the following command in project directory

```bash
flutter pub get
```

## Usage

### Initialize the Client

```dart
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';

void main() {
  final client = MusicBrainzApiClient();

  // Use the client to interact with the MusicBrainz API
  final id = '606bf117-494f-4864-891f-09d63ff6aa4b';  // Example artist ID
  final response = await client.artists.get(id);
  print(response);

  // Close the client when done
  client.close();
}
```

### Fetch artist, event, instrument, label, place, recording, release, release-group, series, work, and url Details

```dart
var result = await client.areas.search('america');
print(result);
result = await client.areas.get('f33958ac-4198-3ce8-a751-1c44d9b4063a');
print(result);
final result = await client.artists.browse(
        relatedEntity,
        'f33958ac-4198-3ce8-a751-1c44d9b4063a',
        inc: ['aliases'],
      );
print(result);
//Unpaginate results
final result = await client.areas.search('city', paginated: false);
print(result);
```

### Fetch Genre Details

```dart
var result = await client.genres.get('9067dfc9-4bfe-4e2b-b2f2-88fb30dd5c46');
print(result);
result = await client.genres.all();
print(result);
```

### Fetch Cover art

```dart
var result = await client.coverArt.get('76df3287-6cda-33eb-8e9a-044b5e15ffdd','release');
print(result);
```

### Running Specific Tests

- **Run all tests**:
  ```bash
  flutter test
  ```

- **Run a specific test file**:
  ```bash
  flutter test test/artist_test.dart
  ```

## Contributing

Contributions are welcome! If you find a bug or want to add a feature, please open an issue or submit a pull request.

1. Fork the repository.
2. Create a new branch in your own fork (`git checkout -b feature/YourFeatureName`).
3. Make sure you create test cases for your changes and test thoroughly. Include tests in your commit.
4. Commit your changes to the new branch (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature/YourFeatureName`).
6. Open a pull request in this repo.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [MusicBrainz API](https://musicbrainz.org/doc/MusicBrainz_API) for providing the music database.
- [Flutter](https://flutter.dev/) for the awesome framework.