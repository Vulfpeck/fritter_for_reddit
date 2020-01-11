import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  var _subredditGoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        child: Consumer<UserInformationProvider>(
            builder: (BuildContext context, UserInformationProvider model, _) {
          if (model.signedIn) {
            if (model.state == ViewState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (model.state == ViewState.Idle) {
              return Container(
                color: Theme.of(context).cardColor,
                child: CustomScrollView(
                  slivers: <Widget>[
                    DrawerSliverAppBar(),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          index = index - 2;
                          if (index == -2) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: ListTile(
                                title: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Goto subreddit',
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  autofocus: false,
                                  autocorrect: false,
                                  controller: _subredditGoController,
                                  onSubmitted: (value) {
                                    loadNewSubreddit(context, value);
                                  },
                                ),
                                trailing: IconButton(
                                  tooltip: "Go",
                                  icon: Icon(
                                    Icons.arrow_forward,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    return Navigator.of(
                                      context,
                                      rootNavigator: false,
                                    ).push(
                                      CupertinoPageRoute(
                                        builder: (context) => SubredditFeedPage(
                                          subreddit:
                                              _subredditGoController.text,
                                        ),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                          if (index == -1) {
                            return ListTile(
                              title: Text(
                                'Frontpage',
                                style: Theme.of(context).textTheme.subhead,
                              ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/default_icon.png'),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                              onTap: () {
                                Navigator.of(context, rootNavigator: false)
                                    .pop();
                                return Navigator.of(
                                  context,
                                  rootNavigator: false,
                                ).push(
                                  CupertinoPageRoute(
                                    builder: (context) => SubredditFeedPage(
                                      subreddit: "",
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );
                              },
                            );
                          }
                          return ListTile(
                            title: Text(
                              model.userSubreddits.data.children[index]
                                  .display_name,
                              style: Theme.of(context).textTheme.subhead,
                            ),
                            leading: CircleAvatar(
                              backgroundImage: model.userSubreddits.data
                                          .children[index].community_icon !=
                                      ""
                                  ? CachedNetworkImageProvider(
                                      model.userSubreddits.data.children[index]
                                          .community_icon,
                                    )
                                  : model.userSubreddits.data.children[index]
                                              .icon_img !=
                                          ""
                                      ? CachedNetworkImageProvider(
                                          model.userSubreddits.data
                                              .children[index].icon_img,
                                        )
                                      : AssetImage('assets/default_icon.png'),
                              backgroundColor: model.userSubreddits.data
                                          .children[index].primary_color ==
                                      ""
                                  ? Theme.of(context).accentColor
                                  : HexColor(
                                      model.userSubreddits.data.children[index]
                                          .primary_color,
                                    ),
                            ),
                            onTap: () {
                              Navigator.of(context, rootNavigator: false).pop();
                              return Navigator.of(
                                context,
                                rootNavigator: false,
                              ).push(
                                CupertinoPageRoute(
                                  builder: (context) => SubredditFeedPage(
                                    subreddit: model.userSubreddits.data
                                        .children[index].display_name,
                                  ),
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                          );
                        },
                        childCount:
                            model.userSubreddits.data.children.length + 2,
                      ),
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
              );
            }
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                DrawerSliverAppBar(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                              hintText: 'Goto subreddit',
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 2,
                                ),
                              ),
                            ),
                            autofocus: false,
                            autocorrect: false,
                            controller: _subredditGoController,
                            onSubmitted: (value) {
                              loadNewSubreddit(context, value);
                            },
                          ),
                          trailing: IconButton(
                            tooltip: "Go",
                            icon: Icon(
                              Icons.arrow_forward,
                            ),
                            onPressed: () {
                              loadNewSubreddit(
                                  context, _subredditGoController.text);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Card(
                      child: Padding(
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
                              height: 150,
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
                              height: 8,
                            ),
                            Text(
                              "Sign in to Fritter for maximum fun",
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
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }

  loadNewSubreddit(BuildContext context, String text) {
    final text = _subredditGoController.text.replaceAll(" ", "");
    Navigator.of(context).pop();
    return Navigator.of(
      context,
      rootNavigator: false,
    ).push(
      CupertinoPageRoute(
        builder: (context) => SubredditFeedPage(
          subreddit: text,
        ),
        fullscreenDialog: true,
      ),
    );
  }
}

class DrawerSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      automaticallyImplyLeading: true,
      expandedHeight: 170,
      iconTheme: Theme.of(context).iconTheme,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Subreddits",
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
