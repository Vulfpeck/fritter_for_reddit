import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/models/postsfeed/posts_feed_entity.dart';

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
      _selectedSort = changeCommentSortConvertToEnum[widget.item.suggestedSort];
    } else {
      _selectedSort = CommentSortTypes.Best;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .color
                    .withOpacity(0.6),
              ),
              label: Text(
                'Refresh',
                style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .color
                        .withOpacity(0.8)),
              ),
              onPressed: () {
                Provider.of<CommentsProvider>(context).fetchComments(
                  subredditName: widget.item.subreddit,
                  requestingRefresh: true,
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
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    capitalizeString(
                      changeCommentSortConvertToString[_selectedSort],
                    ),
                    style: Theme.of(context).textTheme.caption,
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
                  _selectedSort = changeCommentSortConvertToEnum[value];
                });
                Provider.of<CommentsProvider>(context).fetchComments(
                  requestingRefresh: true,
                  subredditName: widget.item.subreddit,
                  postId: widget.item.id,
                  sort: _selectedSort,
                );
              },
              items: <String>[
                changeCommentSortConvertToString[CommentSortTypes.Best],
                changeCommentSortConvertToString[CommentSortTypes.Top],
                changeCommentSortConvertToString[CommentSortTypes.New],
                changeCommentSortConvertToString[
                    CommentSortTypes.Controversial],
                changeCommentSortConvertToString[CommentSortTypes.Old],
                changeCommentSortConvertToString[CommentSortTypes.QandA],
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
        ),
      ),
    );
  }

  String capitalizeString(String input) {
    return input.replaceFirst(input[0], input[0].toUpperCase());
  }
}
