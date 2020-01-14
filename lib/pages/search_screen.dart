import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/providers/search_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comments_sheet.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';

import '../exports.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();

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
                  SearchBarWidget(),
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
                  SliverList(
                    delegate: model.subQueryResult.subreddits != null
                        ? model.subredditQueryLoadingState == ViewState.Busy
                            ? SliverChildListDelegate(
                                [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 16,
                                    ),
                                    child: LinearProgressIndicator(),
                                  )
                                ],
                              )
                            : SliverChildBuilderDelegate(
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
                                                  model
                                                      .subQueryResult.subreddits
                                                      .elementAt(index)
                                                      .keyColor,
                                            )
                                          : Theme.of(context).accentColor,
                                    ),
                                    onTap: () => Navigator.of(context,
                                            rootNavigator: false)
                                        .push(
                                      CupertinoPageRoute(
                                        fullscreenDialog: true,
                                        builder: (BuildContext context) =>
                                            SubredditFeedPage(
                                          subreddit: model
                                              .subQueryResult.subreddits
                                              .elementAt(index)
                                              .name,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount:
                                    model.subQueryResult.subreddits.length,
                              )
                        : SliverChildListDelegate([]),
                  ),
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
                  SliverList(
                    delegate: model.postsQueryResult.data != null
                        ? model.postsQueryLoadingState == ViewState.Busy
                            ? SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, top: 8, bottom: 8),
                                  child: LinearProgressIndicator(),
                                )
                              ])
                            : SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (index.isOdd) {
                                    return Divider();
                                  } else {
                                    final item = model
                                        .postsQueryResult.data.children
                                        .elementAt(index ~/ 2)
                                        .data;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Material(
                                        color: Theme.of(context).cardColor,
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<CommentsProvider>(
                                                    context)
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
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                        __) {
                                                  return CommentsSheet(item);
                                                },
                                                fullscreenDialog: true,
                                                opaque: false,
                                                transitionsBuilder: (context,
                                                    primaryanimation,
                                                    secondaryanimation,
                                                    child) {
                                                  return FadeTransition(
                                                    child: child,
                                                    opacity: CurvedAnimation(
                                                      parent: primaryanimation,
                                                      curve: Curves
                                                          .linearToEaseOut,
                                                      reverseCurve:
                                                          Curves.easeInToLinear,
                                                    ),
                                                  );
                                                },
                                                transitionDuration: Duration(
                                                  milliseconds: 450,
                                                ),
                                              ),
                                            );
                                          },
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
                                      ),
                                    );
                                  }
                                },
                                childCount: model
                                        .postsQueryResult.data.children.length *
                                    2,
                              )
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
      stretch: false,
      title: Text("Search"),
      textTheme: Theme.of(context).textTheme,
      brightness: MediaQuery.of(context).platformBrightness,
      backgroundColor: Theme.of(context).cardColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 56,
              left: 16.0,
              right: 16.0),
          child: Consumer(
            builder:
                (BuildContext context, SearchProvider model, Widget child) {
              return TextField(
                controller: controller,
                autocorrect: false,
                enableSuggestions: true,
                autofocus: false,
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
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
                      color:
                          Theme.of(context).textTheme.title.color.withOpacity(
                                0.3,
                              ),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => controller.clear(),
                  ),
                ),
//                onChanged: (String value) async {
//                  if (value == "") return;
//                  Provider.of<SearchProvider>(context)
//                      .queryReddit(query: value);
//                },
                onSubmitted: (String textValue) {
                  Provider.of<SearchProvider>(context)
                      .queryReddit(query: textValue);
                  Provider.of<SearchProvider>(context)
                      .searchPosts(query: textValue);
                },
              );
            },
          ),
        ),
      ),
      expandedHeight: MediaQuery.of(context).padding.top + 72,
    );
  }
}
