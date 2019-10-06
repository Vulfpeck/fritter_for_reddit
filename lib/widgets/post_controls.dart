import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';

class PostControls extends StatefulWidget {
  final PostsFeedDataChildrenData postData;

  PostControls(this.postData);
  @override
  _PostControlsState createState() => _PostControlsState();
}

class _PostControlsState extends State<PostControls> {
  bool likes;
  @override
  void initState() {
    likes = widget.postData.likes;
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.postData.author + " • " + widget.postData.domain,
                  ),
                  Text(
                    getTimePosted(widget.postData.createdUtc),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      widget.postData.subredditNamePrefixed,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Theme.of(context).accentColor),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    color: Colors.black54,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        elevation: 10,
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                                              'assets/default_icon.png'),
                                        ),
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
                      if (likes == null) {
                        widget.postData.score++;
                        likes = true;
                        model.vote(widget.postData.name, 1);
                      } else if (likes == false) {
                        widget.postData.score += 2;
                        likes = true;
                        model.vote(widget.postData.name, 1);
                      } else {
                        widget.postData.score--;
                        likes = null;
                        model.vote(widget.postData.name, 0);
                      }
                    },
                    color: likes == true ? Colors.orange : Colors.grey,
                    splashColor: Colors.orange,
                  ),
                  Text(
                    widget.postData.score.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: likes == null
                          ? Colors.black54
                          : likes == true ? Colors.orange : Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    color: likes == false ? Colors.deepPurple : Colors.grey,
                    onPressed: () {
                      if (likes == null) {
                        widget.postData.score--;
                        likes = false;
                        model.vote(widget.postData.name, -1);
                      } else if (likes == true) {
                        widget.postData.score -= 2;
                        likes = false;
                        model.vote(widget.postData.name, -1);
                      } else {
                        widget.postData.score++;
                        likes = null;
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
