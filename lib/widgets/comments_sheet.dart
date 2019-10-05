import 'package:flutter/material.dart';

class CommentsSheet extends StatefulWidget {
  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 1.0,
      minChildSize: 0.2,
      initialChildSize: 0.8,
      expand: false,
      builder: (BuildContext context, ScrollController controller) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return ListTile(
              title: Text('List Item'),
            );
          },
          controller: controller,
        );
      },
    );
  }
}
