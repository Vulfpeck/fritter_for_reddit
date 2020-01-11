import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/providers/search_provider.dart';

import '../exports.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        body: Consumer(
          builder: (BuildContext context, SearchProvider model, _) {
            return CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SearchBarWidget(),
                SliverSafeArea(
                  bottom: true,
                  top: false,
                  sliver: SliverList(
                    delegate: model.subQueryResult.subreddits != null
                        ? model.subredditQueryLoadingState == ViewState.Busy
                            ? SliverChildListDelegate(
                                [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8,
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
                                              null
                                          ? CachedNetworkImageProvider(model
                                              .subQueryResult.subreddits
                                              .elementAt(index)
                                              .iconImg)
                                          : Container(),
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
                ),
              ],
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
      title: Text("Search"),
      backgroundColor: Theme.of(context).cardColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
          ),
          child: Consumer(
            builder:
                (BuildContext context, SearchProvider model, Widget child) {
              return TextField(
                controller: controller,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  filled: true,
                  hintText: "Search for subs, posts, users",
                  prefixIcon: Icon(Icons.search),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => controller.clear(),
                  ),
                ),
                onChanged: (String value) async {
                  if (value == "") return;
                  Provider.of<SearchProvider>(context)
                      .queryReddit(query: value);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
