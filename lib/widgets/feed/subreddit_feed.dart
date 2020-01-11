import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/widgets/comments/comments_sheet.dart';
import 'package:flutter_provider_app/widgets/common/translucent_app_bar_bg.dart';
import 'package:flutter_provider_app/widgets/drawer/drawer.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';

class SubredditFeed extends StatefulWidget {
  @override
  _SubredditFeedState createState() => _SubredditFeedState();
}

// TODO : implement posting to subreddits
class _SubredditFeedState extends State<SubredditFeed>
    with TickerProviderStateMixin {
  ScrollController _controller;
  String sortSelectorValue = "Best";
  GlobalKey key = GlobalKey();
  @override
  void initState() {
    _controller = new ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_controller.position.maxScrollExtent - _controller.offset <= 100 &&
        Provider.of<FeedProvider>(context).loadMorePostsState !=
            ViewState.Busy) {
      Provider.of<FeedProvider>(context).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider model, _) {
        return CustomScrollView(
          controller: _controller,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
//          CupertinoSliverNavigationBar(
//            largeTitle: Text(
//              'Feed',
//            ),
//          ),
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
                    print(
                        'position of dropdown: ' + positionDropDown.toString());
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
                  icon: Icon(Icons.group_work),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: false).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context) => LeftDrawer(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
              pinned: true,
              snap: true,
              floating: true,
              primary: true,
              elevation: 0,
              brightness: MediaQuery.of(context).platformBrightness,
              backgroundColor: Colors.transparent,
              flexibleSpace: model.subredditInformationError
                  ? FlexibleSpaceBar(
                      background: Container(
                        color: Theme.of(context).accentColor.withOpacity(0.2),
                      ),
                    )
                  : FlexibleSpaceBar(
                      background: Stack(
                        children: <Widget>[
                          Container(
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Color.fromARGB(200, 255, 255, 255)
                                : Color.fromARGB(100, 0, 0, 0),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: model.state == ViewState.Busy
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : TranslucentAppBarBackground(),
                          ),
                        ],
                      ),
                    ),
              expandedHeight:
                  model.currentPage == CurrentPage.FrontPage ? 144 : 200,
            ),
//          SliverPersistentHeader(
//            delegate:
//                TranslucentSliverAppDelegate(MediaQuery.of(context).padding),
//            pinned: false,
//            floating: false,
//          ),

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
                            return Material(
                              borderRadius: BorderRadius.circular(0.0),
                              clipBehavior: Clip.antiAlias,
                              color: Theme.of(context).cardColor,
                              child: InkWell(
                                enableFeedback: false,
                                onDoubleTap: () {
                                  if (item.isSelf == false) {
                                    launchURL(context, item.url);
                                  }
                                },
                                onTap: () => _openComments(item, context),
                                child: Hero(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        FeedCard(
                                          item,
                                        ),
                                        PostControls(item),
                                      ],
                                    ),
                                  ),
                                  tag: item.id,
                                ),
                              ),
                            );
                          },
                          childCount:
                              model.postFeed.data.children.length * 2 + 1,
                        )
                      : SliverChildListDelegate([]),
            )
          ],
        );
      },
    );
  }

  void _openComments(PostsFeedDataChildrenData item, BuildContext context) {
    Provider.of<CommentsProvider>(context).fetchComments(
      requestingRefresh: false,
      subredditName: item.subreddit,
      postId: item.id,
      sort: item.suggestedSort != null
          ? changeCommentSortConvertToEnum[item.suggestedSort]
          : CommentSortTypes.Best,
    );
    Navigator.of(context).push(
//      CupertinoPageRoute(
//        builder: (BuildContext context) {
//          return CommentsSheet(item);
//        },
//        title: "Comments",
//      ),
//      CustomRoute(
//        enterPage: CommentsSheet(
//          item,
//        ),
//        exitPage: this.widget,
//      ),
      PageRouteBuilder(
        pageBuilder: (BuildContext context, _, __) {
          return CommentsSheet(item);
        },
        fullscreenDialog: true,
        opaque: false,
        transitionsBuilder:
            (context, primaryanimation, secondaryanimation, child) {
          return FadeTransition(
            child: child,
            opacity: CurvedAnimation(
              parent: primaryanimation,
              curve: Curves.easeInToLinear,
              reverseCurve: Curves.linearToEaseOut,
            ),
          );
        },
        transitionDuration: Duration(
          milliseconds: 350,
        ),
      ),
//      SlideUpRoute(
//        builder: (BuildContext context) => CommentsSheet(
//          item,
//        ),
//      ),
    );
  }
}
