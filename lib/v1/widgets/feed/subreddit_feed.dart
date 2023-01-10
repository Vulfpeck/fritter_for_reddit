import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/helpers/functions/conversion_functions.dart';
import 'package:fritter_for_reddit/v1/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/v1/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/v1/models/subreddit_info/subreddit_information_entity.dart';
import 'package:fritter_for_reddit/v1/providers/settings_change_notifier.dart';
import 'package:fritter_for_reddit/v1/widgets/comments/comments_page.dart';
import 'package:fritter_for_reddit/v1/widgets/common/gallery_card.dart';
import 'package:fritter_for_reddit/v1/widgets/common/go_to_subreddit.dart';
import 'package:fritter_for_reddit/v1/widgets/common/photo_grid.dart';
import 'package:fritter_for_reddit/v1/widgets/desktop/desktop_subreddit_feed.dart';
import 'package:fritter_for_reddit/v1/widgets/drawer/drawer.dart';
import 'package:fritter_for_reddit/v1/widgets/feed/feed_list_item.dart';

import 'post_controls.dart';

class SubredditFeed extends StatefulWidget {
  final String? pageTitle;

  SubredditFeed({this.pageTitle = ""});

  @override
  _SubredditFeedState createState() => _SubredditFeedState();
}

// TODO : implement posting to subreddits
class _SubredditFeedState extends State<SubredditFeed>
    with TickerProviderStateMixin {
  ScrollController? _controller;
  String sortSelectorValue = "Best";
  GlobalKey key = new GlobalKey();

  SettingsNotifier get settingsNotifier =>
      SettingsNotifier.of(context, listen: false);

  @override
  void initState() {
    _controller = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  FeedProvider get feedProvider =>
      Provider.of<FeedProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (OverscrollNotification notification) {
        if (!notification.overscroll.isNegative &&
            Provider.of<FeedProvider>(context, listen: false)
                    .loadMorePostsState !=
                ViewState.busy) {
          Provider.of<FeedProvider>(context, listen: false).loadMorePosts();
        }

        return false;
      },
      child: Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider model, _) {
          bool hasError = model.subInformationLoadingError ||
              model.feedInformationLoadingError;
          bool userInfoProviderIsIdle =
              Provider.of<UserInformationProvider>(context, listen: false)
                      .state ==
                  ViewState.Idle;
          bool feedProviderIsIdle = model.state == ViewState.Idle;
          return Scrollbar(
            child: CustomScrollView(
              controller: _controller,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: Theme.of(context).iconTheme,
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      key: key,
                      icon: Icon(
                        Icons.sort,
                      ),
                      onSelected: (value) {
                        final RenderBox box =
                            key.currentContext!.findRenderObject() as RenderBox;
                        final positionDropDown = box.localToGlobal(Offset.zero);
                        // print(
                        if (value == "Top") {
                          sortSelectorValue = "Top";
                          showMenu(
                            position: RelativeRect.fromLTRB(
                              positionDropDown.dx,
                              positionDropDown.dy,
                              0,
                              0,
                            ),
                            context: context,
                            items: <String>[
                              'Day',
                              'Week',
                              'Month',
                              'Year',
                              'All',
                            ].map((value) {
                              return PopupMenuItem<String>(
                                value: value,
                                child: ListTile(
                                  title: Text(value),
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: false)
                                        .pop();

                                    model.updateSorting(
                                      sortBy: "/top/.json?sort=top&t=$value",
                                      loadingTop: true,
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        } else if (value == 'Close' ||
                            value == sortSelectorValue) {
                        } else {
                          sortSelectorValue = value;
                          feedProvider.updateSorting(
                            sortBy: value,
                            loadingTop: false,
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return <String>[
                          'Best',
                          'Hot',
                          'Top',
                          'New',
                          'Controversial',
                          'Rising'
                        ].map((String value) {
                          return new PopupMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList();
                      },
                      onCanceled: () {},
                      initialValue: sortSelectorValue,
                    ),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      color: Theme.of(context).iconTheme.color,
                      onPressed: () {
                        showSubInformationSheet(context);
                      },
                    )
                  ],
                  pinned: true,
                  snap: true,
                  floating: true,
                  primary: true,
                  elevation: 0,
                  brightness: MediaQuery.of(context).platformBrightness,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  textTheme: Theme.of(context).textTheme,
                  centerTitle: true,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          model.currentPage != CurrentPage.frontPage
                              ? model.currentSubreddit.toString()
                              : 'Frontpage',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        child: IconButton(
                          icon: Icon(Icons.expand_more),
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: false).push(
                            CupertinoPageRoute(
                              maintainState: true,
                              builder: (context) => LeftDrawer(
                                mode: Mode.mobile,
                              ),
                              fullscreenDialog: true,
                            ),
                          ),
                          color: Theme.of(context).accentColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
//        return ListView.builder(
//          itemBuilder: (BuildContext context, int index) {
//            var item = model.postFeed.data.children[index].data;
//            return Material(
//              borderRadius: BorderRadius.circular(0.0),
//              clipBehavior: Clip.antiAlias,
//              color: Theme.of(context).cardColor,
//              child: InkWell(
//                enableFeedback: false,
//                onDoubleTap: () {
//                  if (item.isSelf == false) {
//                    launchURL(Theme.of(context).primaryColor, item.url);
//                  }
//                },
//                onTap: () {
//                  _openComments(item, context, index);
//                },
//                child: Column(
//                  children: <Widget>[
//                    FeedCard(
//                      item,
//                    ),
//                    PostControls(
//                      postData: item,
//                    ),
//                  ],
//                ),
//              ),
//            );
//          },
//          controller: _controller,
//          itemCount: model.postFeed.data.children.length,
//          cacheExtent: 20,
//          addAutomaticKeepAlives: false,
//        );
        },
      ),
    );
  }

  void showSubInformationSheet(BuildContext context) {
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            builder: (BuildContext context, ScrollController controller) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).scaffoldBackgroundColor),
            padding: const EdgeInsets.all(8.0),
            child: Consumer(
              builder: (BuildContext context, FeedProvider model, _) {
                var headerColor =
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? TransparentHexColor("#000000", "80")
                        : TransparentHexColor("#FFFFFF", "aa");

                if (feedProvider.subredditInformationEntity != null &&
                    feedProvider.subredditInformationEntity!.data!
                            .bannerBackgroundColor !=
                        "") {
                  headerColor = TransparentHexColor(
                    feedProvider
                        .subredditInformationEntity!.data!.bannerBackgroundColor!,
                    "50",
                  );
                }
                return Container(
                  // Don't wrap this in any SafeArea widgets, use padding instead
                  padding: EdgeInsets.all(0),
                  color: headerColor,
                  // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
                  child: Container(),
                );
              },
            ),
          );
        });
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

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final PostsFeedDataChildrenData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FeedCard(
          item,
        ),
        PostControls(
          postData: item,
        ),
      ],
    );
  }
}
