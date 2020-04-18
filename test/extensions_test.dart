import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';
import 'package:http/http.dart';

main() {
  test('Ensure convertSubredditsToLinks returns markdown formatted links', () {
    const input = 'These are subReddits. /r/one, /r/two, /r/three';
    const String convertedInput =
        'These are subReddits. [/r/one](/r/one), [/r/two](/r/two), [/r/three](/r/three)';
    expect(input.withSubredditLinksAsMarkdownLinks, convertedInput);
  });
}

class TestClass {
  final String name;
  final Uint8List imageData;

  TestClass(this.name, this.imageData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestClass &&
          runtimeType == other.runtimeType &&
          listEquals<int>(imageData, other.imageData);

  @override
  int get hashCode => imageData.length;
}
