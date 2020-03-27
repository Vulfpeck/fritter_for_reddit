import 'package:fritter_for_reddit/models/subreddits/child.dart';

class Children {
  final List<SubredditListChild> children;

  Children.fromList(List<dynamic> list)
      : children = list.map((var v) {
          return new SubredditListChild.fromJsonMap(v["data"]);
        }).toList();
}
