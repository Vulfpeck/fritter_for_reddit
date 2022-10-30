import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v1/widgets/common/expansion_tile.dart';

class ClassicFeedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RestrictedExpansionTile(title: Text('Title'));
  }
}
