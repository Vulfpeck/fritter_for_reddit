import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String title;
  final Color color;

  const ListHeader({Key key, @required this.title, this.color = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      dense: true,
    );
  }
}

class SliverListHeader extends StatelessWidget {
  final String title;
  final Color color;

  const SliverListHeader(
      {Key key, @required this.title, this.color = Colors.blue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListHeader(
        title: title,
        color: color,
      ),
    );
  }
}
