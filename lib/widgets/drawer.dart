import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/hex_color.dart';
import 'package:flutter_provider_app/providers/feed_provider.dart';

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserInformationProvider>(
          builder: (BuildContext context, UserInformationProvider model, _) {
        if (model.signedIn) {
          if (model.state == ViewState.Busy) {
            return Center(child: CircularProgressIndicator());
          } else if (model.state == ViewState.Idle) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  brightness: Brightness.light,
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
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline,
                            ),
                            Text(
                              (model.userInformation.link_karma +
                                  model.userInformation.comment_karma)
                                  .toString() +
                                  " Karma",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subhead,
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.refresh),
                                    onPressed: model.performTokenRefresh),
                                IconButton(
                                  icon: Icon(Icons.beach_access),
                                  onPressed: model.signOutUser,
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
                      index = index - 1;
                      if (index == -1) {
                        return ListTile(
                          title: Text(
                            'Frontpage',
                            style: Theme
                                .of(context)
                                .textTheme
                                .subhead,
                          ),
                          leading: CircleAvatar(
                            backgroundImage:
                            AssetImage('assets/default_icon.png'),
                            backgroundColor: Theme
                                .of(context)
                                .accentColor,
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
                          model
                              .userSubreddits.data.children[index].display_name,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subhead,
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
                              ? Theme
                              .of(context)
                              .accentColor
                              : HexColor(
                            model.userSubreddits.data.children[index]
                                .primary_color,
                          ),
                        ),
                        onTap: () {
                          print(model.userSubreddits.data.children[index]
                              .display_name);
                          Provider.of<FeedProvider>(context).fetchPostsListing(
                              currentSubreddit: model.userSubreddits.data
                                  .children[index].display_name);
                          if (Scaffold
                              .of(context)
                              .isDrawerOpen) {
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                    childCount: model.userSubreddits.data.children.length + 1,
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
                model.performAuthentication();
              },
            ),
          );
        }
        return Container();
      }),
    );
  }
}
