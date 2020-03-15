import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comments_bar.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';
import 'package:html_unescape/html_unescape.dart';

import 'comment_list_item.dart';

class CommentsScreen extends StatelessWidget {
  final PostsFeedDataChildrenData postData;
  static final _unescape = HtmlUnescape();
  CommentsScreen({@required this.postData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, CommentsProvider model, _) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                title: Text("Comments"),
                automaticallyImplyLeading: true,
                iconTheme: Theme.of(context).iconTheme,
                backgroundColor: Theme.of(context).cardColor,
                floating: true,
                brightness: MediaQuery.of(context).platformBrightness,
                pinned: false,
                snap: true,
                elevation: 0,
                textTheme: Theme.of(context).textTheme,
              ),
//                BlurredSliverAppBar(
//                  title: "Comments",
//                ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      Material(
                        color: Theme.of(context).cardColor,
                        child: InkWell(
                          onTap: () {
                            if (postData.isSelf == false) {
                              launchURL(context, postData.url);
                            }
                          },
                          child: FeedCard(postData),
                        ),
                      ),
                      postData.isSelf && postData.selftextHtml != null
                          ? FeedCardBodySelfText(
                              selftextHtml: postData.selftextHtml,
                            )
                          : Container(),
                      PostControls(
                        postData: postData,
                      ),
                      Divider(),
                      CommentsControlBar(postData),
                      Divider(),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ]),
              ),
              SliverList(
                delegate: model.commentsLoadingState == ViewState.Busy
                    ? SliverChildListDelegate(
                        <Widget>[
                          SizedBox(
                            height: 64.0,
                          ),
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                        ],
                      )
                    : model.commentsMap[postData.id] == null ||
                            model.commentsMap[postData.id].length == 0
                        ? SliverChildListDelegate(
                            <Widget>[
                              SizedBox(
                                height: 64.0,
                              ),
                              Center(
                                child: Icon(Icons.info_outline),
                              ),
                              Center(
                                child: Text("No Comments"),
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                            ],
                          )
                        : SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              var commentItem =
                                  model.commentsMap[postData.id].elementAt(
                                (index),
                              );
                              return CommentItem(
                                commentItem,
                                postData.name,
                                postData.id,
                                index,
                              );
                            },
                            childCount: model.commentsMap[postData.id].length,
                          ),
//
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
