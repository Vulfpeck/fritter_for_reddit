import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TranslucentAppBarBackground extends StatefulWidget {
  /// give the page a title in case it is a feed such as front page, all,
  /// or popular
  final String pageTitle;

  TranslucentAppBarBackground({this.pageTitle = ""});
  @override
  _TranslucentAppBarBackgroundState createState() =>
      _TranslucentAppBarBackgroundState();
}

class _TranslucentAppBarBackgroundState
    extends State<TranslucentAppBarBackground> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
