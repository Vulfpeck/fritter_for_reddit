import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/hex_color.dart';
import 'package:flutter_provider_app/pages/web_view_sign_in.dart';
import 'package:flutter_provider_app/providers/feed_provider.dart';
import 'package:flutter_provider_app/widgets/common/customScrollPhysics.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  var _subredditGoController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Consumer<UserInformationProvider>(
        builder: (BuildContext context, UserInformationProvider model, _) {
      if (model.signedIn) {
        if (model.state == ViewState.Busy) {
          return Center(child: CircularProgressIndicator());
        } else if (model.state == ViewState.Idle) {
          return CustomScrollView(
            physics: CustomBouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black12,
                automaticallyImplyLeading: false,
                expandedHeight: 150,
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            model.userInformation.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            (model.userInformation.linkKarma +
                                        model.userInformation.commentKarma)
                                    .toString() +
                                " Karma",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: model.performTokenRefresh,
                              ),
                              IconButton(
                                icon: Icon(Icons.beach_access),
                                onPressed: () {
                                  performSignout(context);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    index = index - 2;
                    if (index == -2) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ListTile(
                          title: TextField(
                            decoration: InputDecoration(
                              hintText: 'Goto subreddit',
                              fillColor: Colors.black12,
                              filled: true,
                              border: InputBorder.none,
                            ),
                            controller: _subredditGoController,
                            onSubmitted: (value) {
                              loadNewSubreddit(context, value);
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                            ),
                            onPressed: () {
                              loadNewSubreddit(
                                  context, _subredditGoController.text);
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
                          Navigator.of(context).pop();
                          Provider.of<FeedProvider>(context)
                              .fetchPostsListing();
                        },
                      );
                    }
                    return ListTile(
                      title: Text(
                        model.userSubreddits.data.children[index].display_name,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: model.userSubreddits.data
                                    .children[index].community_icon !=
                                ""
                            ? NetworkImage(model.userSubreddits.data
                                .children[index].community_icon)
                            : model.userSubreddits.data.children[index]
                                        .icon_img !=
                                    ""
                                ? NetworkImage(model.userSubreddits.data
                                    .children[index].icon_img)
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
                        print(model
                            .userSubreddits.data.children[index].display_name);
                        Provider.of<FeedProvider>(context).fetchPostsListing(
                            currentSubreddit: model.userSubreddits.data
                                .children[index].display_name);
                        if (Scaffold.of(context).isDrawerOpen) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                  childCount: model.userSubreddits.data.children.length + 2,
                ),
              ),
            ],
          );
        }
      } else {
        return SafeArea(
          child: ListTile(
            title: Text("Sign into reddit"),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.person_outline,
              ),
            ),
            onTap: () {
              authenticateUser(model, context);
            },
          ),
        );
      }
      return Container();
    }));
  }

  Future<void> authenticateUser(
      UserInformationProvider model, BuildContext context) async {
    bool res = true;
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return WebViewSignIn();
    })).then((val) {
      res = val;
      print("Auth Navigator result: " + res.toString());
    });
    res = await model.performAuthentication() && res;
    print("final res: " + res.toString());
    Navigator.pop(context);
    if (res) {
      await Provider.of<FeedProvider>(context).fetchPostsListing();
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Authentication failed bitches'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Retry'),
                onPressed: () {
                  authenticateUser(model, context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  loadNewSubreddit(BuildContext context, String text) {
    final text = _subredditGoController.text.replaceAll(" ", "");
    Provider.of<FeedProvider>(context)
        .fetchPostsListing(currentSubreddit: text, currentSort: "hot");
    Navigator.of(context).pop();
  }

  Future<void> performSignout(BuildContext context) async {
    await Provider.of<UserInformationProvider>(context).signOutUser();
    await Provider.of<FeedProvider>(context).fetchPostsListing(
      currentSort: "hot",
    );
  }
}
