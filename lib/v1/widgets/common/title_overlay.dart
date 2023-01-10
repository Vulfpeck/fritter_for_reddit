import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TitleOverlay extends StatefulWidget {
  final String? title;
  final Widget child;

  const TitleOverlay({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  TitleOverlayState createState() => TitleOverlayState();
}

class TitleOverlayState extends State<TitleOverlay> {
  bool _shown = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        widget.child,
        SizedBox.expand(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPressStart: (_) => setState(() => _shown = true),
            onLongPressEnd: (_) => setState(() => _shown = false),
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                opacity: _shown ? 1 : 0,
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.87),
                  child: Text(
                    widget.title!,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
