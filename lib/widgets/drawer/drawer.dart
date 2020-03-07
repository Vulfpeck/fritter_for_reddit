import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/hex_to_color_class.dart';
import 'package:flutter_provider_app/widgets/common/go_to_subreddit.dart';
import 'package:flutter_provider_app/widgets/drawer/list_header.dart';

class LeftDrawer extends StatefulWidget {
  final bool firstLaunch;
  final Mode mode;

  LeftDrawer({this.firstLaunch = false, @required this.mode});

  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  final ScrollController _controller = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    if (widget.firstLaunch) {
      Future.delayed(Duration(milliseconds: 800)).then((_) {
        Navigator.of(context, rootNavigator: false).push(
          CupertinoPageRoute(
            maintainState: true,
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
                  SliverListHeader(title: 'Subscribed Subreddits'),
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
                                  backgroundImage: model.userSubreddits.data
                                              .children[index].community_icon !=
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
                                  backgroundColor: model.userSubreddits.data
                                              .children[index].primary_color ==
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
                      [SizedBox(height: MediaQuery.of(context).padding.bottom)],
                    ),
                    if (!model.signedIn)
                      Login()
                    else ...[
                      SliverListHeader(title: 'Subscribed Subreddits'),
                      SliverList(
                        delegate: model.state == ViewState.Idle
                            ? SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (widget.mode == Mode.mobile) {
                                    return SubredditDrawerTile(
                                      focusNode: focusNode,
                                      child: model
                                          .userSubreddits.data.children[index],
                                    );
                                  } else {
                                    return DesktopSubredditDrawerTile(
                                      subreddit: model
                                          .userSubreddits.data.children[index],
                                    );
                                  }
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
                      SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (model.userInformation != null)
                ProfileListTile(
                  name: model.userInformation.name,
                  imageUrl: model.userInformation.iconImg,
                ),
            ],
          ),
        );
      }),
    );
  }
}

class SubredditDrawerTile extends StatelessWidget {
  final Child child;

  const SubredditDrawerTile({
    Key key,
    @required this.focusNode,
    @required this.child,
  }) : super(key: key);

  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        child.display_name,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      leading: CircleAvatar(
        maxRadius: 16,
        backgroundImage: child.community_icon != ""
            ? CachedNetworkImageProvider(
                child.community_icon,
              )
            : child.icon_img != ""
                ? CachedNetworkImageProvider(
                    child.icon_img.asSanitizedImageUrl,
                  )
                : AssetImage('assets/default_icon.png'),
        backgroundColor: child.primary_color == ""
            ? Theme.of(context).accentColor
            : HexColor(
                child.primary_color,
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
              subreddit: child.display_name,
            ),
            fullscreenDialog: false,
          ),
        );
      },
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
        style: Theme.of(context).textTheme.headline6,
      ),
      brightness: MediaQuery.of(context).platformBrightness,
      iconTheme: Theme.of(context).iconTheme,
    );
//    return BlurredSliverAppBar(
//      title: "Subreddits",
//    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
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
                style: Theme.of(context).textTheme.headline4.copyWith(
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "You're not signed in",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Sign in to Fritter to see your subscriptions",
                style: Theme.of(context).textTheme.bodyText2,
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
                    Provider.of<UserInformationProvider>(context, listen: false)
                        .authenticateUser(context);
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 24,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ProfileListTile({
    Key key,
    @required this.imageUrl,
    @required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          imageUrl.asSanitizedImageUrl,
        ),
      ),
      title: Text(name),
      children: <Widget>[
        ListTile(
          title: Text('Logout'),
          onTap: () => UserInformationProvider.of(context).signOutUser(),
        )
      ],
    );
  }
}
