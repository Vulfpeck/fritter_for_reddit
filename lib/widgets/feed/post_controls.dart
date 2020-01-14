import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/functions/conversion_functions.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/pages/subreddit_feed.dart';

class PostControls extends StatelessWidget {
  final PostsFeedDataChildrenData postData;

  PostControls(this.postData);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_upward,
                      size: 16,
                      color: postData.likes == null
                          ? Theme.of(context).textTheme.subtitle.color
                          : postData.likes == true
                              ? Colors.orange
                              : Colors.purple,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      getRoundedToThousand(postData.score),
                      textAlign: TextAlign.center,
                      style: postData.likes == null
                          ? Theme.of(context).textTheme.subtitle
                          : Theme.of(context).textTheme.subtitle.copyWith(
                                color: postData.likes == null
                                    ? Colors.grey
                                    : postData.likes == true
                                        ? Colors.orange
                                        : Colors.purple,
                              ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: Theme.of(context).textTheme.subtitle.color,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      getRoundedToThousand(postData.numComments),
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).textTheme.subtitle.color,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      getTimePosted(postData.createdUtc),
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_horiz),
                      color: Theme.of(context).textTheme.subtitle.color,
                      onPressed: () => showPostOptions(context),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_upward),
                      onPressed: () {
                        if (Provider.of<UserInformationProvider>(context)
                            .signedIn) {
                          if (postData.likes == true) {
                            model.votePost(id: postData.id, dir: 0);
                          } else {
                            model.votePost(id: postData.id, dir: 1);
                          }
                        } else {
                          buildSnackBar(context);
                        }
                      },
                      color: postData.likes == null || postData.likes == false
                          ? Theme.of(context).textTheme.subtitle.color
                          : Colors.orange,
                      splashColor: Colors.orange,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_downward),
                      color: postData.likes == null || postData.likes == true
                          ? Theme.of(context).textTheme.subtitle.color
                          : Colors.purple,
                      onPressed: () {
                        if (Provider.of<UserInformationProvider>(context)
                            .signedIn) {
                          if (postData.likes == false) {
                            model.votePost(id: postData.id, dir: 0);
                          } else {
                            model.votePost(id: postData.id, dir: -1);
                          }
                        } else {
                          buildSnackBar(context);
                        }
                      },
                      splashColor: Colors.deepPurple,
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPostOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return Material(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.3,
            maxChildSize: 0.7,
            minChildSize: 0.1,
            builder: (context, controller) {
              return CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: controller,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      ListTile(
                        title: Text('View Profile'),
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      ),
                      ListTile(
                        title: Text('View Subreddit'),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/default_icon.png',
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          return Navigator.of(
                            context,
                            rootNavigator: false,
                          ).push(
                            CupertinoPageRoute(
                              builder: (context) => SubredditFeedPage(
                                subreddit: postData.subreddit,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                      )
                    ]),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
