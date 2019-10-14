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

// TODO : implement posting to subreddits
class _FeedListState extends State<FeedList> {
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
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: Theme.of(context).iconTheme,
            actions: <Widget>[
              PopupMenuButton<String>(
                key: key,
                icon: Icon(
                  Icons.sort,
                ),
                //TODO : implement top sorting functionality
                onSelected: (value) {
                  final RenderBox box = key.currentContext.findRenderObject();
                  final positionDropDown = box.localToGlobal(Offset.zero);
                  print('position of dropdown: ' + positionDropDown.toString());
                  if (value == "Top") {
                    showMenu(
                      position: RelativeRect.fromLTRB(
                        positionDropDown.dx,
                        positionDropDown.dy,
                        0,
                        0,
                      ),
                      context: context,
                      items: <String>[
                        'Today',
                        'Week',
                        'Month',
                        'Year',
                        'All TIme'
                      ].map((value) {
                        return PopupMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  } else if (value == 'Close' || value == sortSelectorValue) {
                  } else {
                    sortSelectorValue = value;
                    Provider.of<FeedProvider>(context).fetchPostsListing(
                        currentSort: value, currentSubreddit: model.sub);
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
            ],
            pinned: false,
            snap: true,
            floating: true,
            primary: true,
            elevation: 0,
            brightness: MediaQuery.of(context).platformBrightness,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: <Widget>[
                  Container(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Color.fromARGB(150, 255, 255, 255)
                        : Color.fromARGB(150, 0, 0, 0),
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
