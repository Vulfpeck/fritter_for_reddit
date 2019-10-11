import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/pages/subreddit_feed.dart';

class PostControls extends StatefulWidget {
  final PostsFeedDataChildrenData postData;

  PostControls(this.postData);
  @override
  _PostControlsState createState() => _PostControlsState();
}

class _PostControlsState extends State<PostControls> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Divider(),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          widget.postData.subredditNamePrefixed,
                          style: Theme.of(context).textTheme.subtitle.copyWith(
                                color: Theme.of(context).accentColor,
                              ),
                        ),
                      ),
                      Text(
                        'u/' + widget.postData.author,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        widget.postData.domain,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        getTimePosted(widget.postData.createdUtc),
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.comment,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(widget.postData.numComments.toString() + ' Comments'),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Colors.grey,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        elevation: 10,
                        builder: (context) {
                          return DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.3,
                            maxChildSize: 0.7,
                            minChildSize: 0.1,
                            builder: (context, controller) {
                              return CustomScrollView(
                                controller: controller,
                                physics: BouncingScrollPhysics(),
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
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubredditFeedPage(
                                                subreddit:
                                                    widget.postData.subreddit,
                                              ),
                                            )),
                                      )
                                    ]),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      if (widget.postData.likes == null) {
                        widget.postData.score++;
                        widget.postData.likes = true;
                        model.vote(widget.postData.name, 1);
                      } else if (widget.postData.likes == false) {
                        widget.postData.score += 2;
                        widget.postData.likes = true;
                        model.vote(widget.postData.name, 1);
                      } else {
                        widget.postData.score--;
                        widget.postData.likes = null;
                        model.vote(widget.postData.name, 0);
                      }
                    },
                    color: widget.postData.likes == null ||
                            widget.postData.likes == false
                        ? Colors.grey
                        : Colors.orange,
                    splashColor: Colors.orange,
                  ),
                  Text(
                    widget.postData.score.toString(),
                    textAlign: TextAlign.center,
                    style: widget.postData.likes == null
                        ? Theme.of(context).textTheme.button
                        : Theme.of(context).textTheme.button.copyWith(
                              color: widget.postData.likes == null
                                  ? Colors.grey
                                  : widget.postData.likes == true
                                      ? Colors.orange
                                      : Colors.purple,
                            ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    color: widget.postData.likes == null ||
                            widget.postData.likes == true
                        ? Colors.grey
                        : Colors.purple,
                    onPressed: () {
                      if (widget.postData.likes == null) {
                        widget.postData.score--;
                        widget.postData.likes = false;
                        model.vote(widget.postData.name, -1);
                      } else if (widget.postData.likes == true) {
                        widget.postData.score -= 2;
                        widget.postData.likes = false;
                        model.vote(widget.postData.name, -1);
                      } else {
                        widget.postData.score++;
                        widget.postData.likes = null;
                        model.vote(widget.postData.name, 0);
                      }
                    },
                    splashColor: Colors.deepPurple,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String getTimePosted(double orig) {
    DateTime postDate = DateTime.fromMillisecondsSinceEpoch(
      orig.floor() * 1000,
      isUtc: true,
    );
    Duration difference = DateTime.now().toUtc().difference(postDate);
    if (difference.inDays <= 0) {
      if (difference.inHours <= 0) {
        if (difference.inMinutes <= 0) {
          return "Few Moments Ago";
        } else {
          return difference.inMinutes.toString() +
              (difference.inMinutes == 1 ? " minute" : " minutes") +
              " ago";
        }
      } else {
        return difference.inHours.toString() +
            (difference.inHours == 1 ? " hour" : " hours") +
            " ago";
      }
    } else {
      return difference.inDays.toString() +
          (difference.inDays == 1 ? " day" : " days") +
          " ago";
    }
  }
}
