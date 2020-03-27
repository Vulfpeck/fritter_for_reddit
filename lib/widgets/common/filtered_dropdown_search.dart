import 'dart:async';

import 'package:flutter/material.dart';

/// The variable [verticalOffset] cannot be null
class FilteredDropdownSearch<T> extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool asSliver;
  final List<T> options;
  final InputDecoration inputDecoration;

  /// The placement of the results List below the TextField.
  final double verticalOffset;

  /// A builder function which returns the item being currently built
  final Widget Function(BuildContext, T) itemBuilder;

  FilteredDropdownSearch({
    Key key,
    @required this.onChanged,
    this.asSliver = false,
    @required this.options,
    this.inputDecoration,
    @required this.itemBuilder,
    this.verticalOffset = 0.0,
  })  : assert(verticalOffset != null),
        assert(options != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        TextField(
          decoration: InputDecoration(border: OutlineInputBorder()),
          onChanged: (value) {
            onChanged(value);
          },
        ),
        Positioned(
          top: 45 + verticalOffset,
          child: Card(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) =>
                    itemBuilder(context, options[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
