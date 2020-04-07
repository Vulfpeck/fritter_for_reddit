import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/helpers/functions/web_view_launch_helper.dart';
import 'package:fritter_for_reddit/helpers/sorting_types/comments_sort_helper.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/widgets/comments/comments_page.dart';
import 'package:fritter_for_reddit/widgets/common/gallery_card.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_subreddit_feed.dart';

class DesktopFeedList extends StatefulWidget {
  final List<PostsFeedDataChild> posts;
  final ViewMode viewMode;

  final bool hasError;
  final bool isLoading;

  DesktopFeedList({
    Key key,
    @required this.posts,
    @required this.viewMode,
    @required this.hasError,
    @required this.isLoading,
  }) : super(key: key);

  @override
  _DesktopFeedListState createState() => _DesktopFeedListState();
}

class _DesktopFeedListState extends State<DesktopFeedList> {
  PersistentBottomSheetController controller;
  List<PostsFeedDataChild> pics = [];

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: widget.viewMode == ViewMode.gallery,
      builder: (context) {
        final List<PostsFeedDataChild> postsWithImages =
            widget.posts.where((element) => element.data.hasImage).toList();

        return SliverGrid.count(
          crossAxisCount: 3,
          children: <Widget>[
            for (final postFeedItem in postsWithImages)
              Card(
                elevation: 3,
                child: GalleryImage(postFeedItem: postFeedItem),
              )
          ],
        );
      },
      fallback: (context) {
        SliverChildDelegate sliverChildDelegate;
        if (widget.hasError) {
          sliverChildDelegate = SliverChildListDelegate([
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(Icons.error_outline),
                Text("Couldn't Load subreddit")
              ],
            )
          ]);
        } else {
          sliverChildDelegate = SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index == widget.posts.length) {
                if (widget.isLoading) {
                  return Material(
                    color: Theme.of(context).cardColor,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.bottom * 2,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }

              final item = widget.posts[index].data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Divider(),
                  DesktopPostCard(
                    item: item,
                    onTap: () {
                      _openComments(item, context, index);
                    },
                    onDoubleTap: () {
                      if (item.isTextPost == false) {
                        launchURL(Theme.of(context).primaryColor, item.url);
                      }
                    },
                  ),
                ],
              );
            },
            childCount: widget.posts.length,
          );
        }
        return SliverList(
          delegate: sliverChildDelegate,
        );
      },
    );
  }

  void _openComments(
      PostsFeedDataChildrenData item, BuildContext context, int index) {
    Provider.of<CommentsProvider>(context, listen: false).fetchComments(
      requestingRefresh: false,
      subredditName: item.subreddit,
      postId: item.id,
      sort: item.suggestedSort != null
          ? changeCommentSortConvertToEnum[item.suggestedSort]
          : CommentSortTypes.Best,
    );
    Navigator.of(context).push(
//      PageRouteBuilder(
//        pageBuilder: (BuildContext context, _, __) {
//          return CommentsSheet(item);
//        },
//        fullscreenDialog: false,
//        opaque: true,
//        transitionsBuilder:
//            (context, primaryanimation, secondaryanimation, child) {
//          return FadeTransition(
//            child: child,
//            opacity: CurvedAnimation(
//              parent: primaryanimation,
//              curve: Curves.easeInToLinear,
//              reverseCurve: Curves.linearToEaseOut,
//            ),
//          );
//        },
//        transitionDuration: Duration(
//          milliseconds: 250,
//        ),
//      ),

      CupertinoPageRoute(
        maintainState: true,
        builder: (BuildContext context) {
          return DesktopCommentsScreen(
            postData: item,
          );
        },
      ),
    );
  }
}
