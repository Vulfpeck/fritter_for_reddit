import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/providers/search_provider.dart';
import 'package:fritter_for_reddit/widgets/comments/comments_page.dart';
import 'package:fritter_for_reddit/widgets/feed/feed_list_item.dart';

import '../exports.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: FloatingActionButton(
            child: Icon(Icons.arrow_upward),
            backgroundColor: Theme.of(context).accentColor,
            elevation: 0,
            mini: true,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 350),
                curve: Curves.linearToEaseOut,
              );
            },
          ),
        ),
        body: Consumer(
          builder: (BuildContext context, SearchProvider model, _) {
            return CupertinoScrollbar(
              controller: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SearchBarWidget(
                    focusNode: focusNode,
                  ),

                  // subreddit headings
                  SliverList(
                    delegate: model.subQueryResult.subreddits != null
                        ? SliverChildListDelegate(
                            [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 24.0,
                                  bottom: 8.0,
                                ),
                                child: Text("Subreddits"),
                              ),
                            ],
                          )
                        : SliverChildListDelegate([]),
                  ),

                  // list of relevant subreddits
                  SliverList(
                    delegate: model.subQueryResult.subreddits != null
                        ? SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                  model.subQueryResult.subreddits
                                      .elementAt(index)
                                      .name,
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: model
                                                  .subQueryResult.subreddits
                                                  .elementAt(index)
                                                  .iconImg !=
                                              "" &&
                                          model.subQueryResult.subreddits
                                                  .elementAt(index)
                                                  .iconImg !=
                                              null
                                      ? CachedNetworkImageProvider(model
                                          .subQueryResult.subreddits
                                          .elementAt(index)
                                          .iconImg)
                                      : AssetImage(
                                          'assets/default_icon.png',
                                        ),
                                  backgroundColor: model
                                              .subQueryResult.subreddits
                                              .elementAt(index)
                                              .keyColor !=
                                          ""
                                      ? HexColor(
                                          "#" +
                                              model.subQueryResult.subreddits
                                                  .elementAt(index)
                                                  .keyColor,
                                        )
                                      : Theme.of(context).accentColor,
                                ),
                                onTap: () {
                                  focusNode.unfocus();
                                  return Navigator.of(context,
                                          rootNavigator: false)
                                      .push(
                                    CupertinoPageRoute(
                                      maintainState: true,
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          SubredditFeedPage(
                                        subreddit: model
                                            .subQueryResult.subreddits
                                            .elementAt(index)
                                            .name,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: model.subQueryResult.subreddits.length,
                          )
                        : SliverChildListDelegate([]),
                  ),

                  // posts subheading
                  SliverList(
                    delegate: model.postsQueryResult.data != null
                        ? SliverChildListDelegate(
                            [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 24.0,
                                  bottom: 8.0,
                                ),
                                child: Text("Posts"),
                              ),
                            ],
                          )
                        : SliverChildListDelegate([]),
                  ),

                  // list of posts from query
                  SliverList(
                    delegate: model.postsQueryResult.data != null
                        ? SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index.isOdd) {
                                return Divider();
                              } else {
                                final item = model
                                    .postsQueryResult.data.children
                                    .elementAt(index ~/ 2)
                                    .data;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, top: 4.0),
                                  child: Material(
                                    color: Theme.of(context).cardColor,
                                    child: InkWell(
                                      onTap: () {
                                        focusNode.unfocus();
                                        Provider.of<CommentsProvider>(context)
                                            .fetchComments(
                                          requestingRefresh: false,
                                          subredditName: item.subreddit,
                                          postId: item.id,
                                          sort: item.suggestedSort != null
                                              ? changeCommentSortConvertToEnum[
                                                  item.suggestedSort]
                                              : CommentSortTypes.Best,
                                        );
                                        Navigator.of(context).push(
//                                          PageRouteBuilder(
//                                            pageBuilder:
//                                                (BuildContext context, _, __) {
//                                              return CommentsSheet(item);
//                                            },
//                                            fullscreenDialog: false,
//                                            opaque: true,
//                                            transitionsBuilder: (context,
//                                                primaryanimation,
//                                                secondaryanimation,
//                                                child) {
//                                              return FadeTransition(
//                                                child: child,
//                                                opacity: CurvedAnimation(
//                                                  parent: primaryanimation,
//                                                  curve: Curves.easeInToLinear,
//                                                  reverseCurve:
//                                                      Curves.easeInToLinear,
//                                                ),
//                                              );
//                                            },
//                                            transitionDuration: Duration(
//                                              milliseconds: 250,
//                                            ),
//                                          ),
                                          CupertinoPageRoute(
                                            maintainState: true,
                                            builder: (BuildContext context) {
                                              return DesktopCommentsScreen(
                                                postData: item,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          FeedCard(
                                            item,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            childCount:
                                model.postsQueryResult.data.children.length * 2,
                          )
                        : SliverChildListDelegate([]),
                  ),
                  SliverList(
                    delegate: model.subQueryResult.subreddits == null &&
                            model.postsQueryResult.data == null
                        ? SliverChildListDelegate(
                            [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Icon(
                                Icons.search,
                                color: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color
                                          .withOpacity(
                                            0.3,
                                          ),
                                    )
                                    .color,
                                size: 56,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  "To get the results, search you must.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color
                                            .withOpacity(
                                              0.7,
                                            ),
                                      ),
                                ),
                              ),
                            ],
                          )
                        : SliverChildListDelegate([]),
                  ),
                  SliverList(
                    delegate:
                        model.subredditQueryLoadingState == ViewState.Busy ||
                                model.postsQueryLoadingState == ViewState.Busy
                            ? SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: LinearProgressIndicator(),
                                )
                              ])
                            : SliverChildListDelegate([]),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                      )
                    ]),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatefulWidget {
  final FocusNode focusNode;

  SearchBarWidget({this.focusNode});
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: true,
      elevation: 0,
      floating: true,
      centerTitle: true,
      stretch: false,
      title: Text(
        "Search",
        style: Theme.of(context).textTheme.headline6,
      ),
      textTheme: Theme.of(context).textTheme,
      brightness: MediaQuery.of(context).platformBrightness,
      backgroundColor: Theme.of(context).cardColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Consumer(
                builder:
                    (BuildContext context, SearchProvider model, Widget child) {
                  return TextField(
                    controller: controller,
                    focusNode: widget.focusNode,
                    autocorrect: false,
                    enableSuggestions: true,
                    autofocus: false,
                    keyboardAppearance:
                        MediaQuery.of(context).platformBrightness,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      filled: true,
                      hintText: "Search for subreddits and posts",
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .textTheme
                              .title
                              .color
                              .withOpacity(
                                0.3,
                              ),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          model.clearResults();
                        },
                      ),
                    ),
                    onChanged: (String textValue) async {
                      if (textValue == "") return;
                      Provider.of<SearchProvider>(context, listen: false)
                          .searchSubreddits(query: textValue);
                    },
                    onSubmitted: (String textValue) {
                      if (textValue != "") {
                        Provider.of<SearchProvider>(context, listen: false)
                            .searchSubreddits(query: textValue);
                        Provider.of<SearchProvider>(context, listen: false)
                            .searchPosts(query: textValue);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      expandedHeight: MediaQuery.of(context).padding.top + 96,
    );
  }
}
