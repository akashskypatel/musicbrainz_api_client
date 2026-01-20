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

// ignore_for_file: avoid_print

import 'unit/area_test.dart' as area;
import 'unit/artist_test.dart' as artist;
import 'unit/event_test.dart' as event;
import 'unit/genre_test.dart' as genre;
import 'unit/instrument_test.dart' as instrument;
import 'unit/label_test.dart' as label;
import 'unit/place_test.dart' as place;
import 'unit/recording_test.dart' as recording;
import 'unit/release_group_test.dart' as release_group;
import 'unit/release_test.dart' as release;
import 'unit/series_test.dart' as series;
import 'unit/url_test.dart' as url;
import 'unit/work_test.dart' as work;
import 'unit/cover_art_test.dart' as cover_art;

void main() {
  area.main();
  artist.main();
  event.main();
  genre.main();
  instrument.main();
  label.main();
  place.main();
  recording.main();
  release_group.main();
  release.main();
  series.main();
  url.main();
  work.main();
  cover_art.main();
}
