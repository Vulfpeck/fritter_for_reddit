import 'package:fritter_for_reddit/models/subreddits/child.dart';

class Children {
  final List<Child> children;

  Children.fromList(List<dynamic> list)
      : children = list.map((var v) {
          return new Child.fromJsonMap(v["data"]);
        }).toList();
}
