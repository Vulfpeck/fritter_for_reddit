import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';

class CommentsControlBar extends StatefulWidget {
  final PostsFeedDataChildrenData item;

  CommentsControlBar(this.item);

  @override
  _CommentsControlBarState createState() => _CommentsControlBarState();
}

class _CommentsControlBarState extends State<CommentsControlBar> {
  CommentSortTypes _selectedSort;

  initState() {
    if (widget.item.suggestedSort != null && widget.item.suggestedSort != "") {
      _selectedSort = ChangeCommentSortConvertToEnum[widget.item.suggestedSort];
    } else {
      _selectedSort = CommentSortTypes.Best;
    }
    super.initState();
  }

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
          onPressed: () {
            Provider.of<CommentsProvider>(context).fetchComments(
              subredditName: widget.item.subreddit,
              postId: widget.item.id,
              sort: _selectedSort,
            );
          },
        ),
        Expanded(
          child: Container(),
        ),
        DropdownButton<String>(
          underline: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Sort By',
                style: Theme.of(context).textTheme.overline,
              ),
              Text(
                capitalizeString(
                  ChangeCommentSortConvertToString[_selectedSort],
                ),
              ),
            ],
          ),
          icon: Icon(
            Icons.sort,
            color: Colors.grey,
          ),
          isExpanded: false,
          isDense: false,
          onChanged: (value) {
            setState(() {
              _selectedSort = ChangeCommentSortConvertToEnum[value];
            });
            Provider.of<CommentsProvider>(context).fetchComments(
              subredditName: widget.item.subreddit,
              postId: widget.item.id,
              sort: _selectedSort,
            );
          },
          items: <String>[
            ChangeCommentSortConvertToString[CommentSortTypes.Best],
            ChangeCommentSortConvertToString[CommentSortTypes.Top],
            ChangeCommentSortConvertToString[CommentSortTypes.New],
            ChangeCommentSortConvertToString[CommentSortTypes.Controversial],
            ChangeCommentSortConvertToString[CommentSortTypes.Old],
            ChangeCommentSortConvertToString[CommentSortTypes.QA],
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value.toString(),
              child: new Text(
                capitalizeString(value),
              ),
            );
          }).toList(),
        ),
        SizedBox(width: 16.0),
      ],
    );
  }

  String capitalizeString(String input) {
    return input.replaceFirst(input[0], input[0].toUpperCase());
  }
}
