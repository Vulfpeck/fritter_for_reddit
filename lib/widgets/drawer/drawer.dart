import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/widgets/common/go_to_subreddit.dart';

class LeftDrawer extends StatefulWidget {
  final bool firstLaunch;

  LeftDrawer({this.firstLaunch = false});

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  final ScrollController _controller = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    if (widget.firstLaunch) {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Navigator.of(context, rootNavigator: false).push(
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return SubredditFeedPage(
                subreddit: "",
                frontPageLoad: true,
              );
            },
          ),
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: Consumer<UserInformationProvider>(
            builder: (BuildContext context, UserInformationProvider model, _) {
          if (model.signedIn) {
            return Container(
              color: Theme.of(context).cardColor,
              child: CupertinoScrollbar(
                controller: _controller,
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  slivers: <Widget>[
                    DrawerSliverAppBar(),
                    GoToSubredditWidget(
                      focusNode: focusNode,
                    ),
                    SliverList(
                      delegate: model.state == ViewState.Idle
                          ? SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    model.userSubreddits.data.children[index]
                                        .display_name,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                  leading: CircleAvatar(
                                    maxRadius: 16,
                                    backgroundImage: model
                                                .userSubreddits
                                                .data
                                                .children[index]
                                                .community_icon !=
                                            ""
                                        ? CachedNetworkImageProvider(
                                            model.userSubreddits.data
                                                .children[index].community_icon,
                                          )
                                        : model.userSubreddits.data
                                                    .children[index].icon_img !=
                                                ""
                                            ? CachedNetworkImageProvider(
                                                model.userSubreddits.data
                                                    .children[index].icon_img,
                                              )
                                            : AssetImage(
                                                'assets/default_icon.png'),
                                    backgroundColor: model
                                                .userSubreddits
                                                .data
                                                .children[index]
                                                .primary_color ==
                                            ""
                                        ? Theme.of(context).accentColor
                                        : HexColor(
                                            model.userSubreddits.data
                                                .children[index].primary_color,
                                          ),
                                  ),
                                  onTap: () {
                                    focusNode.unfocus();
                                    return Navigator.of(
                                      context,
                                      rootNavigator: false,
                                    ).push(
                                      CupertinoPageRoute(
                                        builder: (context) => SubredditFeedPage(
                                          subreddit: model.userSubreddits.data
                                              .children[index].display_name,
                                        ),
                                        fullscreenDialog: false,
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount:
                                  model.userSubreddits.data.children.length,
                            )
                          : SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: LinearProgressIndicator(),
                              ),
                            ]),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                              height: MediaQuery.of(context).padding.bottom)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CupertinoScrollbar(
              controller: _controller,
              child: CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _controller,
                slivers: <Widget>[
                  DrawerSliverAppBar(),
                  GoToSubredditWidget(
                    focusNode: focusNode,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            SizedBox(
                              height: 48,
                            ),
                            Text(
                              "Hello 🥳",
                              style: Theme.of(context)
                                  .textTheme
                                  .display1
                                  .copyWith(
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "You're not signed in",
                              style: Theme.of(context).textTheme.headline,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Sign in to Fritter to see your subscriptions",
                              style: Theme.of(context).textTheme.body2,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 56.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    14,
                                  ),
                                ),
                                child: Text("Sign In"),
                                onPressed: () {
                                  model.authenticateUser(context);
                                },
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom + 24,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}

class DrawerSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      textTheme: Theme.of(context).textTheme,
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      elevation: 0,
      expandedHeight: 56,
      title: Text(
        "Subreddits",
        style: Theme.of(context).textTheme.title,
      ),
      brightness: MediaQuery.of(context).platformBrightness,
      iconTheme: Theme.of(context).iconTheme,
    );
//    return BlurredSliverAppBar(
//      title: "Subreddits",
//    );
  }
}
