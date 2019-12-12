import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comment_list_item.dart';
import 'package:flutter_provider_app/widgets/comments/comments_bar.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';

class CommentsSheet extends StatefulWidget {
  final PostsFeedDataChildrenData item;
  CommentsSheet(this.item);

  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  double _scaffoldScale = 1.0;
  @override
  void initState() {
    _scrollController = new ScrollController()
      ..addListener(() {
//        if (_scrollController.position.atEdge) {
//          _scrollController.position.activity
//              .dispatchOverscrollNotification(metrics, context, overscroll);
//        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Post id is " + widget.item.name);
    return Transform.scale(
      scale: _scaffoldScale,
      child: Consumer(
        builder: (BuildContext context, CommentsProvider model, _) {
          return Scaffold(
            body: Hero(
              tag: widget.item.id,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: CustomScrollView(
                  controller: _scrollController,
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
                                  if (widget.item.isSelf == false) {
                                    print(widget.item.url);
                                    launchURL(context, widget.item.url);
                                  }
                                },
                                child: FeedCard(widget.item),
                              ),
                            ),
                            CommentsControlBar(widget.item),
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
                                        model.commentsList.elementAt(index);
                                    return CommentItem(
                                      item,
                                      widget.item.name,
                                      widget.item.id,
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
