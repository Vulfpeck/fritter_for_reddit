import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/helpers/functions/conversion_functions.dart';
import 'package:fritter_for_reddit/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/providers/settings_change_notifier.dart';

import 'package:fritter_for_reddit/widgets/common/go_to_subreddit.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_feed_list.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_feed_list_item.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_sliver_app_bar.dart';
import 'package:fritter_for_reddit/widgets/drawer/drawer.dart';
import 'package:fritter_for_reddit/widgets/feed/post_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DesktopSubredditFeed extends StatefulWidget {
  DesktopSubredditFeed();

  @override
  _DesktopSubredditFeedState createState() => _DesktopSubredditFeedState();
}

// TODO : implement posting to subreddits
class _DesktopSubredditFeedState extends State<DesktopSubredditFeed>
    with TickerProviderStateMixin {
  ScrollController _controller;

  @override
  void initState() {
    _controller = new ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    if (_controller.position.maxScrollExtent - _controller.offset <= 400 &&
        Provider.of<FeedProvider>(context, listen: false).loadMorePostsState !=
            ViewState.busy) {
      Provider.of<FeedProvider>(context, listen: false).loadMorePosts();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FeedProvider get feedProvider =>
      Provider.of<FeedProvider>(context, listen: false);

  SettingsNotifier get settingsNotifier =>
      Provider.of<SettingsNotifier>(context, listen: true);

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (BuildContext context, FeedProvider feedProvider, _) {
        final SubredditInfo subredditInfo = feedProvider.subStream.value;
        if (feedProvider.postFeed == null) {
          return LinearProgressIndicator();
        }
        return Container(
          constraints: BoxConstraints(maxWidth: 700),
          child: CustomScrollView(
            controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              ConditionalBuilder(
                condition: feedProvider.state == ViewState.busy,
                builder: (context) => SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SkeletonAnimation(
                        gradientColor: Theme.of(context).dividerColor,
                        shimmerColor: Theme.of(context).dividerColor,
                        child: Container(
                          width: 60,
                          height: 40,
                        ),
                      ),
                    ),
                    title: SkeletonAnimation(
                      gradientColor: Theme.of(context).dividerColor,
                      shimmerColor: Theme.of(context).dividerColor,

                      child: SizedBox(
                        width: 40,
                        height: 10,
                        child: Container(),
                      ),
                    ),
                    subtitle: SkeletonAnimation(
                      shimmerColor: Theme.of(context).dividerColor,

                      child: SizedBox(
                        width: 40,
                        height: 10,
                        child: Container(),
                      ),
                    ),
                  );
                })),
                fallback: (context) => DesktopFeedList(
                  posts: feedProvider.postFeed.data.children,
                  viewMode: settingsNotifier.state.viewMode,
                  hasError: feedProvider.subLoadingError ||
                      feedProvider.feedInformationLoadingError,
                  isLoading: feedProvider.loadMorePostsState == ViewState.busy,
                ),
              )
            ],
          ),
        );
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
          return Material(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).scaffoldBackgroundColor),
              padding: const EdgeInsets.all(8.0),
              child: Consumer(
                builder: (BuildContext context, FeedProvider model, _) {
                  var headerColor = MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? TransparentHexColor("#000000", "80")
                      : TransparentHexColor("#FFFFFF", "aa");

                  if (feedProvider.subredditInformationEntity != null &&
                      feedProvider.subredditInformationEntity.data
                              .bannerBackgroundColor !=
                          "") {
                    headerColor = TransparentHexColor(
                      feedProvider.subredditInformationEntity.data
                          .bannerBackgroundColor,
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
                            ? feedProvider.currentPage == CurrentPage.frontPage
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ElevatedButton(
                                        child: Text('Logout'),
                                        onPressed: () {
                                          SharedPreferences.getInstance()
                                              .then((value) => value.clear());
                                        },
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            'Front Page',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                      LeftDrawer(
                                                    mode: Mode.desktop,
                                                  ),
                                                  fullscreenDialog: false,
                                                ),
                                              );
                                            },
                                            color:
                                                Theme.of(context).accentColor,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                        feedProvider.subStream
                                                            .value.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
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
                                                        .headline5
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                    overflow: TextOverflow.fade,
                                                    textAlign: TextAlign.center,
                                                    softWrap: false,
                                                  ),
                                                  Text(
                                                    getRoundedToThousand(
                                                            feedProvider
                                                                .subredditInformationEntity
                                                                .data
                                                                .subscribers) +
                                                        " Subscribers",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1,
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  if (feedProvider
                                                          .subredditInformationEntity
                                                          .data
                                                          .userIsSubscriber !=
                                                      null)
                                                    TextButton(
                                                      child: ConditionalBuilder(
                                                        condition: feedProvider
                                                                .partialState ==
                                                            ViewState.busy,
                                                        builder: (_) =>
                                                            Container(
                                                          width: 24.0,
                                                          height: 24.0,
                                                          child: Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ),
                                                        fallback: (_) => Text(
                                                          feedProvider
                                                                  .subredditInformationEntity
                                                                  .data
                                                                  .userIsSubscriber
                                                              ? 'Subscribed'
                                                              : 'Join',
                                                        ),
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
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                  );
                },
              ),
            ),
          );
        });
      },
    );
  }
}

class ViewSwitcherIconButton extends StatelessWidget {
  final ViewMode viewMode;
  final ValueChanged<ViewMode> onChanged;

  const ViewSwitcherIconButton({
    Key key,
    @required this.viewMode,
    @required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (viewMode) {
      case ViewMode.card:
        iconData = Icons.view_agenda;
        break;
      case ViewMode.gallery:
        iconData = Icons.photo_library;
        break;
    }
    return IconButton(
      icon: Icon(iconData),
      onPressed: () => onChanged(getNextViewMode()),
    );
  }

  ViewMode getNextViewMode() {
    final index = ViewMode.values.indexOf(viewMode);
    final length = ViewMode.values.length;
    if (index < length - 1) {
      return ViewMode.values[index + 1];
    } else {
      return ViewMode.values[index - length + 1];
    }
  }
}

enum ViewMode { card, gallery }

class DesktopPostCard extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const DesktopPostCard({
    Key key,
    @required this.item,
    @required this.onTap,
    @required this.onDoubleTap,
  }) : super(key: key);

  final PostsFeedDataChildrenData item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: <Widget>[
          DesktopFeedCard(
            post: item,
          ),
          PostControls(
            postData: item,
          ),
        ],
      ),
      onTap: onTap,
      onDoubleTap: onDoubleTap,
    );
  }
}
