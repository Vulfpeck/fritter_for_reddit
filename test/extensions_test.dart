import 'package:flutter_test/flutter_test.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';

main() {
  test('Ensure convertSubredditsToLinks returns markdown formatted links', () {
    const input = 'These are subReddits. /r/one, /r/two, /r/three';
    const String convertedInput =
        'These are subReddits. [/r/one](/r/one), [/r/two](/r/two), [/r/three](/r/three)';
    expect(input.withSubredditLinksAsMarkdownLinks, convertedInput);
  });
}
