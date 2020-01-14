import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../exports.dart';

class UserProfileScreen extends StatelessWidget {
  final ScrollController controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder:
          (BuildContext context, UserInformationProvider model, Widget child) {
        return Scaffold(
          body: Padding(
            padding: MediaQuery.of(context)
                .removeViewPadding(
                  removeBottom: true,
                )
                .padding,
            child: Center(
              child: CupertinoScrollbar(
                controller: controller,
                child: CustomScrollView(
                  controller: controller,
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    model.state == ViewState.Busy
                        ? SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),
                          )
                        : model.signedIn
                            ? SignedInProfileContent(model: model)
                            : SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 16.0,
                                        right: 16,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .title
                                                      .color,
                                                ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text(
                                            "You're not signed in",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "Sign in to Fritter",
                                            style: Theme.of(context)
                                                .textTheme
                                                .body2,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 32,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            height: 56.0,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                  ],
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SignedInProfileContent extends StatelessWidget {
  final UserInformationProvider model;

  SignedInProfileContent({@required this.model});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 24,
              ),
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  model.userInformation.iconImg,
                ),
                minRadius: 56,
                maxRadius: 56,
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                model.userInformation.name,
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Link Karma",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.link,
                            color: Theme.of(context).textTheme.subtitle.color,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            model.userInformation.linkKarma.toString(),
                            style: Theme.of(context).textTheme.title,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Comment Karma",
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Theme.of(context).textTheme.subtitle.color,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            model.userInformation.commentKarma.toString(),
                            style: Theme.of(context).textTheme.title,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 24.0),
                  child: Text("Miscellaneous settings"),
                ),
                ListTile(
                  title: Text("Refresh auth token"),
                  leading: Icon(
                    Icons.refresh,
                    color: Theme.of(context).accentColor,
                  ),
                  subtitle: Text(
                      "Do this if you're having trouble leading comments while you're signed in"),
                  onTap: model.performTokenRefresh,
                ),
                ListTile(
                  title: Text("Sign out of Fritter"),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).accentColor,
                  ),
                  subtitle: Text("Leaving already?"),
                  onTap: () async {
                    await model.signOutUser();
                    await Provider.of<FeedProvider>(context).fetchPostsListing(
                      currentSort: "hot",
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
