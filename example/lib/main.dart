import 'dart:convert';
import 'dart:io';

import 'package:fuzzy/data/result.dart';
import 'package:musicbrainz_api_client/musicbrainz_api_client.dart';
import 'package:discogs_api_client/discogs_api_client.dart';
import 'package:fuzzy/fuzzy.dart';

Future<dynamic> getArtistDetailsMB(String name) async {
  final _mb = MusicBrainzApiClient();

  var res = await _mb.artists.search(name, limit: 100);

  var _results = List<dynamic>.from(
    res['artists'],
  ).where((e) => e['score'] >= 80);

  if (_results.length >= 100) {
    _results = await _mb.artists.search(name, limit: 100, paginated: false);
  }

  if (_results.isNotEmpty) {
    final names =
        _results.map((e) => {'id': e['id'], 'name': e['name']}).toList();
    final WeightedKey keys = WeightedKey(
      name: 'name',
      getter: (e) => e['name'],
      weight: 1,
    );
    final fuzzy = Fuzzy(
      names,
      options: FuzzyOptions(threshold: 1, keys: [keys]),
    );
    final result = fuzzy.search(name)..sort((a, b) {
      final comp = a.score.compareTo(b.score);
      if (comp != 0) {
        return comp;
      }
      return a.matches.first.arrayIndex.compareTo(b.matches.first.arrayIndex);
    });
    if (result.where((e) => e.score == 0.0).isNotEmpty) {
      return _mb.artists.get(
        _results.firstWhere(
          (e) => e['id'] == result.firstWhere((e) => e.score == 0.0).item['id'],
        )['id'],
        inc: [
          'aliases',
          'annotation',
          'tags',
          'recordings',
          'releases',
          'release-groups',
          'works',
          'genres',
          'ratings',
          'url-rels',
        ],
      );
    }
  }
}

Future<dynamic> getArtistDetailsDC(String query) async {
  final _dc = DiscogsApiClient();
  dynamic res;

  if (query == '') return;

  if (int.tryParse(query) != null) {
    final discogsId = int.parse(query);
    res = await _dc.artists.artists(discogsId);
    return res;
  } else {
    res = await _dc.search.search(query: query, type: 'artist');
    final _pages = res['pagination']['pages'];
    var _results = [];

    if (res['results'].length > 0) _results.addAll(res['results']);
    print('pages:$_pages page:${res['pagination']['page']}');

    for (var i = 2; i <= _pages; i++) {
      res = await _dc.search.search(query: query, type: 'artist', page: i);
      if (res['results'].length > 0) _results.addAll(res['results']);
      print('pages:$_pages page:$i');
    }

    if (_results.isEmpty) return;

    final names =
        _results
            .where((e) => e['type'] == 'artist')
            .map((e) => {'id': e['id'], 'title': e['title']})
            .toList();
    final WeightedKey keys = WeightedKey(
      name: 'title',
      getter: (e) => e['title'],
      weight: 1,
    );
    final fuzzy = Fuzzy(
      names,
      options: FuzzyOptions(threshold: 1, keys: [keys]),
    );
    final result = fuzzy.search(query);

    if (result.where((e) => e.score == 0.0).isNotEmpty) {
      return getArtistDetailsDC(
        _results.firstWhere(
          (e) => e['id'] == result.firstWhere((e) => e.score == 0.0).item['id'],
        ),
      );
    }
  }
}

void main() async {
  final client = MusicBrainzApiClient();
  final mbRes = await getArtistDetailsMB('rise against');
  final discogsUrl =
      mbRes['relations'].firstWhere(
        (e) => e['type'] == 'discogs',
      )['url']['resource'];
  final regex = RegExp(r'/artist/(\d+)');
  final match = regex.firstMatch(discogsUrl)?.group(1) ?? '';
  final dcRes = await getArtistDetailsDC(match);

  print(dcRes);

  exit(0);
}
