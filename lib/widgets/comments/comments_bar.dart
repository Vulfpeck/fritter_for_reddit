import 'package:flutter/material.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';

class CommentsControlBar extends StatefulWidget {
  final PostsFeedDataChildrenData item;
  CommentsControlBar(this.item);

  @override
  _CommentsControlBarState createState() => _CommentsControlBarState();
}

class _CommentsControlBarState extends State<CommentsControlBar> {
  GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        FlatButton.icon(
          icon: Icon(Icons.refresh),
          label: Text('Refresh'),
          onPressed: () {},
        ),
        Expanded(
          child: Container(),
        ),
        Text('Sort By'),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.sort,
          ),
          onSelected: (value) {
            print(value);
            if (value == 'top') {
              print(key.currentContext.findRenderObject().semanticBounds);
              showMenu(
                position: RelativeRect.fromRect(
                  key.currentContext
                      .findRenderObject()
                      .paintBounds, // smaller rect, the touch area
                  Offset.zero &
                      key.currentContext
                          .findRenderObject()
                          .semanticBounds
                          .size, // Bigger rect, the entire screen
                ),
                context: context,
                items: ['Today', 'This Week', 'This Month'].map(
                  (String value) {
                    return PopupMenuItem<String>(
                      child: Text(value),
                    );
                  },
                ).toList(),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return <String>[
              'Close',
              'Best',
              'Hot',
              'New',
              'Controversial',
              'top',
              'Rising'
            ].map((String value) {
              return new PopupMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList();
          },
          onCanceled: () {},
        ),
      ],
    );
  }
}
