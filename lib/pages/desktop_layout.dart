import 'package:flutter/material.dart';

class DesktopLayout extends StatefulWidget {
  final Widget leftPanel;
  final Widget content;

  DesktopLayout({
    Key key,
    this.leftPanel,
    this.content,
  }) : super(key: key);

  @override
  _DesktopLayoutState createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(flex: 1, child: widget.leftPanel ?? Container()),
        Divider(),
        Expanded(
          flex: 3,
          child: widget.content ?? Container(),
        )
      ],
    );
  }
}
