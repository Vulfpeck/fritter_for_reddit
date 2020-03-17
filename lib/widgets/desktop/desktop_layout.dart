import 'package:flutter/material.dart';

class DesktopLayout extends StatefulWidget {
  final Widget leftPanel;
  final Widget content;
  final Widget rightPanel;

  DesktopLayout({
    Key key,
    this.leftPanel,
    this.content,
    this.rightPanel,
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
        ),
        if (widget.rightPanel != null) Divider(),
        if (widget.rightPanel != null)
          Expanded(flex: 1, child: widget.rightPanel)
      ],
    );
  }
}
