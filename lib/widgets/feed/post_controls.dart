import 'dart:developer';

import 'package:conditional_wrapper/conditional_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/helpers/functions/conversion_functions.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/pages/subreddit_feed_page.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';
import 'package:image_downloader/image_downloader.dart';

class PostControls extends StatelessWidget {
  final PostsFeedDataChildrenData postData;

  PostControls({@required this.postData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          VotesCountWidget(postData: postData),
          SizedBox(width: 8.0),
          Icon(
            Icons.chat_bubble_outline,
            size: 14,
            color: Theme.of(context).textTheme.subtitle2.color,
          ),
          SizedBox(width: 4.0),
          Text(
            getRoundedToThousand(postData.numComments),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          SizedBox(width: 8.0),
          Icon(
            Icons.access_time,
            size: 14,
            color: Theme.of(context).textTheme.subtitle2.color,
          ),
          SizedBox(width: 4.0),
          Text(
            getTimePosted(postData.createdUtc),
            style: Theme.of(context).textTheme.subtitle2,
          ),
          Expanded(
            child: Container(),
          ),
          PostVoteControls(postData: postData),
        ],
      ),
    );
  }
}

class PostVoteControls extends StatelessWidget {
  const PostVoteControls({
    Key key,
    @required this.postData,
  }) : super(key: key);

  final PostsFeedDataChildrenData postData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.more_horiz),
          color: Theme.of(context).dividerColor.withOpacity(0.4),
          onPressed: () => showPostOptions(context),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
          ),
          onPressed: () async {
            if (Provider.of<UserInformationProvider>(context, listen: false)
                .signedIn) {
              if (postData.likes == true) {
                feedProvider(context).votePost(postItem: postData, dir: 0);
              } else {
                feedProvider(context).votePost(
                  postItem: postData,
                  dir: 1,
                );
              }
            } else {
              buildSnackBar(context);
            }
          },
          color: postData.likes == null || postData.likes == false
              ? Theme.of(context).dividerColor.withOpacity(0.5)
              : Colors.orange,
          splashColor: Colors.orange,
        ),
        IconButton(
          icon: Icon(Icons.arrow_downward),
          color: postData.likes == null || postData.likes == true
              ? Theme.of(context).dividerColor.withOpacity(0.5)
              : Colors.purple,
          onPressed: () async {
            if (Provider.of<UserInformationProvider>(context).signedIn) {
              if (postData.likes == false) {
                feedProvider(context).votePost(
                  postItem: postData,
                  dir: 0,
                );
              } else {
                feedProvider(context).votePost(postItem: postData, dir: -1);
              }
            } else {
              buildSnackBar(context);
            }
          },
          splashColor: Colors.deepPurple,
        ),
      ],
    );
  }

  FeedProvider feedProvider(BuildContext context) =>
      Provider.of<FeedProvider>(context, listen: false);

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
                              maintainState: true,
                              builder: (context) => SubredditFeedPage(
                                subreddit: postData.subreddit,
                              ),
                              fullscreenDialog: false,
                            ),
                          );
                        },
                      ),
                      ConditionalWrapper(
                        builder: (BuildContext context, Widget child) {
                          return AbsorbPointer(
                            absorbing: true,
                            child: child,
                          );
                        },
                        condition: PlatformX.isDesktop,
                        child: ListTile(
                          title: Text('Download'),
                          leading: CircleAvatar(
                            child: Icon(Icons.file_download),
                          ),
                          onTap: () async {
                            if (postData.hasImage) {
                              await Future.forEach(
                                postData.images,
                                (image) async {
                                  String downloadPath =
                                      await ImageDownloader.downloadImage(
                                    image.source.url,
                                    destination: AndroidDestinationType
                                        .directoryPictures,
                                  );

                                  debugPrint('Downloading ${image.source.url}');
                                },
                              );
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      if (kDebugMode) ...[
                        ListTile(
                          title: Text('Open in Chrome'),
                          leading: CircleAvatar(
                            child: Icon(Icons.open_in_browser),
                          ),
                          onTap: () {
                            launchURL(Colors.blue, postData.url);
                          },
                        ),
                        ListTile(
                          title: Text('Pause Debugger'),
                          leading: CircleAvatar(
                            child: Icon(Icons.open_in_browser),
                          ),
                          onTap: () {
                            final currentPostData = postData;
                            debugger();
                          },
                        )
                      ]
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

class VotesCountWidget extends StatelessWidget {
  final PostsFeedDataChildrenData postData;

  VotesCountWidget({@required this.postData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.arrow_upward,
          size: 14,
          color: postData.likes == null
              ? Theme.of(context).textTheme.subtitle2.color
              : postData.likes == true ? Colors.orange : Colors.purple,
        ),
        SizedBox(
          width: 4.0,
        ),
        Text(
          getRoundedToThousand(postData.score),
          textAlign: TextAlign.center,
          style: postData.likes == null
              ? Theme.of(context).textTheme.subtitle2
              : Theme.of(context).textTheme.subtitle2.copyWith(
                    color: postData.likes == null
                        ? Colors.grey
                        : postData.likes == true
                            ? Colors.orange
                            : Colors.purple,
                  ),
        ),
      ],
    );
  }
}
