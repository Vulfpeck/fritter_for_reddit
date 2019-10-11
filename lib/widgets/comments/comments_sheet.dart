import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comment_list_item.dart';
import 'package:flutter_provider_app/widgets/comments/comments_bar.dart';
import 'package:flutter_provider_app/widgets/feed/feed_card.dart';

class CommentsSheet extends StatefulWidget {
  final PostsFeedDataChildrenData item;
  CommentsSheet(this.item);

  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  @override
  Widget build(BuildContext context) {
    print("Post id is " + widget.item.name);
    return DraggableScrollableSheet(
      maxChildSize: 1,
      minChildSize: 0.2,
      initialChildSize: 0.7,
      expand: false,
      builder: (BuildContext context, ScrollController controller) {
        return Consumer(
          builder: (BuildContext context, CommentsProvider model, _) {
            return Scaffold(
              body: CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: controller,
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
                            height: 8.0,
                          ),
                          InkWell(
                            onTap: () {
                              print('tap tap');
                              if (widget.item.isSelf == false) {
                                print(widget.item.url);
                                _launchURL(context, widget.item.url);
                              }
                            },
                            child: widget.item.isSelf
                                ? FeedCardSelfText(widget.item, true)
                                : FeedCardImage(widget.item),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          CommentsControlBar(widget.item),
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ]),
                  ),
                  SliverList(
                    delegate: model.commentsLoadingState == ViewState.Busy
                        ? SliverChildListDelegate(
                            <Widget>[
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                            ],
                          )
                        : SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              var item = model.commentsList.elementAt(index);
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
            );
          },
        );
      },
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: new CustomTabsAnimation(
            startEnter: 'slide_up',
            startExit: 'android:anim/fade_out',
            endEnter: 'android:anim/fade_in',
            endExit: 'slide_down',
          ),
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}

class _TranslucentSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  /// This is required to calculate the height of the bar
  final EdgeInsets safeAreaPadding;

  _TranslucentSliverAppBarDelegate(this.safeAreaPadding);

  @override
  double get minExtent => safeAreaPadding.top;

  @override
  double get maxExtent => minExtent + 100;

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
              height: 48,
              width: 48,
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
