import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comment_list_item.dart';
import 'package:flutter_provider_app/widgets/comments/comments_bar.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';

class CommentsSheet extends StatelessWidget {
  final PostsFeedDataChildrenData item;
  CommentsSheet(this.item);

  @override
  Widget build(BuildContext context) {
    print("Post id is " + item.name);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      movementDuration: Duration(milliseconds: 150),
      background: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: Colors.black.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      onDismissed: (direction) {
        Navigator.pop(context);
      },
      key: Key("test"),
      child: Consumer(
        builder: (BuildContext context, CommentsProvider model, _) {
          return Scaffold(
            body: Hero(
              tag: item.id,
              child: Material(
                color: Colors.transparent,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: _TranslucentSliverAppBarDelegate(
                        MediaQuery.of(context).padding,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 16.0,
                            ),
                            Material(
                              color: Theme.of(context).cardColor,
                              child: InkWell(
                                onTap: () {
                                  print('tap tap');
                                  if (item.isSelf == false) {
                                    print(item.url);
                                    launchURL(context, item.url);
                                  }
                                },
                                child: FeedCard(item),
                              ),
                            ),
                            Divider(),
                            CommentsControlBar(item),
                            Divider(),
                          ],
                        ),
                      ]),
                    ),
                    SliverList(
                      delegate: model.commentsLoadingState == ViewState.Busy
                          ? SliverChildListDelegate(
                              <Widget>[
                                SizedBox(
                                  height: 64.0,
                                ),
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                                SizedBox(
                                  height: 32.0,
                                ),
                              ],
                            )
                          : model.commentsList == null ||
                                  model.commentsList.length == 0
                              ? SliverChildListDelegate(
                                  <Widget>[
                                    SizedBox(
                                      height: 64.0,
                                    ),
                                    Center(
                                      child: Icon(Icons.info_outline),
                                    ),
                                    Center(
                                      child: Text("No Comments"),
                                    ),
                                    SizedBox(
                                      height: 32.0,
                                    ),
                                  ],
                                )
                              : SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    var item =
                                        model.commentsList.elementAt((index));
                                    return CommentItem(
                                      item,
                                      item.data.name,
                                      item.data.id,
                                    );
                                  },
                                  childCount: model.commentsList.length,
                                ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TranslucentSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  /// This is required to calculate the height of the bar
  final EdgeInsets safeAreaPadding;

  _TranslucentSliverAppBarDelegate(this.safeAreaPadding);

  @override
  double get minExtent => safeAreaPadding.top;

  @override
  double get maxExtent => minExtent + 72;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // Don't wrap this in any SafeArea widgets, use padding instead
      padding: EdgeInsets.only(top: safeAreaPadding.top),
      height: maxExtent,
      color: Colors.transparent,
      // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            bottom: 0,
            right: 16,
            child: SizedBox(
              height: 56,
              width: 56,
              child: Material(
                type: MaterialType.button,
                borderRadius: BorderRadius.circular(100),
                elevation: 5,
                color: Theme.of(context).cardColor,
                child: InkWell(
                  splashColor: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TranslucentSliverAppBarDelegate old) {
    return maxExtent != old.maxExtent ||
        minExtent != old.minExtent ||
        safeAreaPadding != old.safeAreaPadding;
  }
}
