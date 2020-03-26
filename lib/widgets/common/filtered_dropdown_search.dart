import 'dart:async';

import 'package:flutter/material.dart';

/// The variable [verticalOffset] cannot be null
class FilteredDropdownSearch extends StatelessWidget {
  final ValueChanged onChanged;
  final bool asSliver;
  final List<String> options;
  final InputDecoration inputDecoration;

  /// The placement of the results List below the TextField.
  final double verticalOffset;

  /// A builder function which returns the item being currently built
  final Widget Function(BuildContext, String) itemBuilder;

  FilteredDropdownSearch({
    Key key,
    @required this.onChanged,
    this.asSliver = false,
    @required this.options,
    this.inputDecoration,
    @required this.itemBuilder,
    this.verticalOffset = 0.0,
  })  : assert(verticalOffset != null),
        super(key: key);

  final StreamController filteredStreamController =
      StreamController.broadcast();

  Stream<List<String>> get filteredStream =>
      filteredStreamController.stream.transform(
        StreamTransformer<dynamic, List<String>>.fromHandlers(
          handleData: (data, sink) {
            List<String> list =
                options.where((element) => element.startsWith(data)).toList();
            sink.add(list);
          },
        ),
      ).asBroadcastStream();

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        TextField(
          onChanged: (value) {
            filteredStreamController.add(value);
          },
        ),
        Positioned(
          top: 45 + verticalOffset,
          child: Card(
            child: StreamBuilder<List<String>>(
                initialData: options,
                stream: filteredStream,
                builder: (context, snapshot) {
                  final filteredList = snapshot.data;
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          itemBuilder(context, filteredList[index]),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
