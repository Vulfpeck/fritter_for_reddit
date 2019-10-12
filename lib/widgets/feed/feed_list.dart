import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comments_sheet.dart';
import 'package:flutter_provider_app/widgets/common/translucent_app_bar_bg.dart';
import 'package:flutter_provider_app/widgets/feed/feed_card.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  ScrollController _controller;
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
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: Theme.of(context).iconTheme,
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.sort,
                ),
                onSelected: (value) {
                  if (value == 'Close') {
                  } else
                    Provider.of<FeedProvider>(context).fetchPostsListing(
                        currentSort: value, currentSubreddit: model.sub);
                },
                itemBuilder: (BuildContext context) {
                  return <String>[
                    'Best',
                    'Hot',
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
              ),
            ],
            pinned: false,
            snap: true,
            floating: true,
            primary: true,
            elevation: 0,
            brightness: MediaQuery.of(context).platformBrightness,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: model.state == ViewState.Busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : TranslucentAppBarBackground(),
            ),
            expandedHeight:
                model.currentPage == CurrentPage.FrontPage ? 150 : 200,
          ),
//          SliverPersistentHeader(
//            delegate:
//                TranslucentSliverAppDelegate(MediaQuery.of(context).padding),
//            pinned: false,
//            floating: false,
//          ),

          SliverList(
            delegate: model.state == ViewState.Idle &&
                    Provider.of<UserInformationProvider>(context).state ==
                        ViewState.Idle
                ? SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == model.postFeed.data.children.length) {
                        return model.loadMorePostsState == ViewState.Busy
                            ? ListTile(
                                title:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : Container();
                      }
                      var item = model.postFeed.data.children[index].data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 4.0,
                        ),
                        child: GestureDetector(
                          onDoubleTap: () {
                            if (item.isSelf == false) {
                              launchURL(context, item.url);
                            }
                          },
                          onTap: () {
                            Provider.of<CommentsProvider>(context)
                                .fetchComments(
                              subredditName: item.subreddit,
                              postId: item.id,
                              sort: item.suggestedSort != null
                                  ? ChangeCommentSortConvertToEnum[
                                      item.suggestedSort]
                                  : CommentSortTypes.Best,
                            );
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return CommentsSheet(item);
                              },
                            );
                          },
                          child: item.isSelf == false && item.preview != null
                              ? FeedCardImage(item)
                              : FeedCardSelfText(item, false),
                        ),
                      );
                    },
                    childCount: model.postFeed.data.children.length + 1,
                  )
                : SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
          )
        ],
      );
    });
  }
}
