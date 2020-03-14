import 'package:flutter/material.dart';

typedef OptionalWrapperBuilder = Widget Function(
    BuildContext context, Widget child);

class OptionalWrapper extends StatelessWidget {
  /// if [condition] evaluates to true, the builder will be run and the child will
  /// be wrapped. If false, only the child is returned.
  final bool condition;
  final OptionalWrapperBuilder builder;
  final Widget child;

  const OptionalWrapper({
    Key key,
    @required this.condition,
    @required this.builder,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return builder(context, child);
    } else {
      return child;
    }
  }
}
