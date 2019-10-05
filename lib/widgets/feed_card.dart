import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:html_unescape/html_unescape.dart';

class FeedCardImage extends StatelessWidget {
  final PostsFeedDataChildrenData _data;

  FeedCardImage(this._data);

  final HtmlUnescape _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final ratio = (mq.width - 16) / _data.preview.images.first.source.width;
    final url = _htmlUnescape.convert(_data.preview.images.first.source.url);
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StickyTag(_data.stickied),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _htmlUnescape.convert(_data.title),
                  style: Theme.of(context).textTheme.title,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image(
              image: CachedNetworkImageProvider(
                url,
              ),
              fit: BoxFit.fitWidth,
              height:
                  _data.preview.images.first.source.height.toDouble() * ratio,
            ),
          ),
          PostControls(_data),
        ],
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.postData.author + " • " + widget.postData.domain,
                  ),
                  Text(
                    getTimePosted(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.postData.createdUtc.floor() * 1000,
                          isUtc: true),
                    ),
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
                      style: Theme.of(context).textTheme.subtitle,
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

  String getTimePosted(DateTime postDate) {
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

class FeedCardSelfText extends StatelessWidget {
  final PostsFeedDataChildrenData _data;

  final HtmlUnescape unescape = new HtmlUnescape();
  FeedCardSelfText(this._data);

  @override
  Widget build(BuildContext context) {
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(_data.selftext);

    String selfText = "";
    for (int i = 0; i < 5 && i < lines.length; i++) {
      selfText += lines.elementAt(i);
    }
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StickyTag(_data.stickied),
          Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 16.0, right: 16.0, bottom: 8.0),
            child: Text(
              unescape.convert(_data.title),
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 0.0, left: 16.0, right: 16.0),
            child: Text(
              selfText,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          PostControls(_data),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class StickyTag extends StatelessWidget {
  final bool _isStickied;

  StickyTag(this._isStickied);

  @override
  Widget build(BuildContext context) {
    return _isStickied
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 12.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Stickied'),
              ),
              color: Colors.green,
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 24.0),
          );
  }
}
