import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/conversion_functions.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/widgets/comments/comments_page.dart';
import 'package:flutter_provider_app/widgets/drawer/drawer.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';

import 'post_controls.dart';

class SubredditFeed extends StatefulWidget {
  final String pageTitle;

  SubredditFeed({this.pageTitle = ""});

  @override
  _SubredditFeedState createState() => _SubredditFeedState();
}

// TODO : implement posting to subreddits
class _SubredditFeedState extends State<SubredditFeed>
    with TickerProviderStateMixin {
  ScrollController _controller;
  String sortSelectorValue = "Best";
  GlobalKey key = new GlobalKey();

  @override
  void initState() {
    _controller = new ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    if (_controller.position.maxScrollExtent - _controller.offset <= 400 &&
        Provider.of<FeedProvider>(context, listen: false).loadMorePostsState !=
            ViewState.Busy) {
      Provider.of<FeedProvider>(context, listen: false).loadMorePosts();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider model, _) {
        return CustomScrollView(
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
                    final RenderBox box = key.currentContext.findRenderObject();
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
                                model.fetchPostsListing(
                                  currentSort: "/top/.json?sort=top&t=$value",
                                  currentSubreddit: model.sub,
                                  loadingTop: true,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    } else if (value == 'Close' || value == sortSelectorValue) {
                    } else {
                      sortSelectorValue = value;
                      Provider.of<FeedProvider>(context).fetchPostsListing(
                        currentSort: value,
                        currentSubreddit: model.sub,
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
                    child: model.currentPage != CurrentPage.FrontPage
                        ? Text(
                            '/r/' + model.sub.toString(),
                            textAlign: TextAlign.center,
                          )
                        : Text('Frontpage', textAlign: TextAlign.center),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: Icon(Icons.expand_more),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: false).push(
                        CupertinoPageRoute(
                          maintainState: true,
                          builder: (context) => LeftDrawer(),
                          fullscreenDialog: true,
                        ),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ],
              ),
            ),
            SliverList(
              delegate: (model.subredditInformationError ||
                      model.feedInformationError)
                  ? SliverChildListDelegate([
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Icon(Icons.error_outline),
                          Text("Couldn't Load subreddit")
                        ],
                      )
                    ])
                  : model.state == ViewState.Idle &&
                          Provider.of<UserInformationProvider>(context).state ==
                              ViewState.Idle
                      ? SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index ==
                                model.postFeed.data.children.length * 2) {
                              return model.loadMorePostsState == ViewState.Busy
                                  ? Material(
                                      color: Theme.of(context).cardColor,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .padding
                                                    .bottom *
                                                2,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container();
                            }

                            if (index % 2 == 1) {
                              return Divider();
                            }
                            var item =
                                model.postFeed.data.children[(index ~/ 2)].data;
                            return InkWell(
                              onDoubleTap: () {
                                if (item.isSelf == false) {
                                  launchURL(context, item.url);
                                }
                              },
                              onTap: () {
                                _openComments(item, context, index);
                              },
                              child: Column(
                                children: <Widget>[
                                  FeedCard(
                                    item,
                                  ),
                                  PostControls(
                                    postData: item,
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount:
                              model.postFeed.data.children.length * 2 + 1,
                        )
                      : SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: LinearProgressIndicator(),
                          )
                        ]),
            )
          ],
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
//                    launchURL(context, item.url);
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
                    feedProvider.subredditInformationEntity.data
                            .bannerBackgroundColor !=
                        "") {
                  headerColor = TransparentHexColor(
                    feedProvider
                        .subredditInformationEntity.data.bannerBackgroundColor,
                    "50",
                  );
                }
                return Container(
                  // Don't wrap this in any SafeArea widgets, use padding instead
                  padding: EdgeInsets.all(0),
                  color: headerColor,
                  // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
                  child: feedProvider != null
                      ? feedProvider.state == ViewState.Idle
                          ? feedProvider.currentPage == CurrentPage.FrontPage
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Front Page',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.chevron_right),
                                          onPressed: () {
                                            return Navigator.of(context,
                                                    rootNavigator: false)
                                                .push(
                                              CupertinoPageRoute(
                                                maintainState: true,
                                                builder: (context) =>
                                                    LeftDrawer(),
                                                fullscreenDialog: false,
                                              ),
                                            );
                                          },
                                          color: Theme.of(context).accentColor,
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 24,
                                      ),
                                      feedProvider.subredditInformationEntity !=
                                              null
                                          ? CircleAvatar(
                                              maxRadius: 24,
                                              minRadius: 24,
                                              backgroundImage: feedProvider
                                                          .subredditInformationEntity
                                                          .data
                                                          .communityIcon !=
                                                      ""
                                                  ? CachedNetworkImageProvider(
                                                      feedProvider
                                                          .subredditInformationEntity
                                                          .data
                                                          .communityIcon,
                                                    )
                                                  : feedProvider
                                                              .subredditInformationEntity
                                                              .data
                                                              .iconImg !=
                                                          ""
                                                      ? CachedNetworkImageProvider(
                                                          feedProvider
                                                              .subredditInformationEntity
                                                              .data
                                                              .iconImg,
                                                        )
                                                      : AssetImage(
                                                          'assets/default_icon.png'),
                                              backgroundColor: feedProvider
                                                          .subredditInformationEntity
                                                          .data
                                                          .primaryColor ==
                                                      ""
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : HexColor(
                                                      feedProvider
                                                          .subredditInformationEntity
                                                          .data
                                                          .primaryColor,
                                                    ),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      widget.pageTitle,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                      feedProvider.subredditInformationEntity !=
                                              null
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  feedProvider
                                                      .subredditInformationEntity
                                                      .data
                                                      .displayNamePrefixed,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                  overflow: TextOverflow.fade,
                                                  textAlign: TextAlign.center,
                                                  softWrap: false,
                                                ),
                                                Text(
                                                  getRoundedToThousand(feedProvider
                                                          .subredditInformationEntity
                                                          .data
                                                          .subscribers) +
                                                      " Subscribers",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subhead,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                feedProvider
                                                            .subredditInformationEntity
                                                            .data
                                                            .userIsSubscriber !=
                                                        null
                                                    ? FlatButton(
                                                        textColor:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .body1
                                                                .color,
                                                        child: feedProvider
                                                                    .partialState ==
                                                                ViewState.Busy
                                                            ? Container(
                                                                width: 24.0,
                                                                height: 24.0,
                                                                child: Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              )
                                                            : Text(
                                                                feedProvider
                                                                        .subredditInformationEntity
                                                                        .data
                                                                        .userIsSubscriber
                                                                    ? 'Subscribed'
                                                                    : 'Join',
                                                              ),
                                                        onPressed: () {
                                                          feedProvider
                                                              .changeSubscriptionStatus(
                                                            feedProvider
                                                                .subredditInformationEntity
                                                                .data
                                                                .name,
                                                            !feedProvider
                                                                .subredditInformationEntity
                                                                .data
                                                                .userIsSubscriber,
                                                          );
                                                        },
                                                      )
                                                    : Container(),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 24.0,
                                      )
                                    ],
                                  ),
                                )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 32, horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Front Page',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
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
    Provider.of<CommentsProvider>(context).fetchComments(
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
          return CommentsScreen(
            postData: item,
          );
        },
      ),
    );
  }
}
