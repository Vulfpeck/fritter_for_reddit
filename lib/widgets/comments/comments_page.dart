import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/providers/comments_provider.dart';
import 'package:fritter_for_reddit/widgets/comments/comments_bar.dart';
import 'package:fritter_for_reddit/widgets/feed/feed_list_item.dart';
import 'package:fritter_for_reddit/widgets/feed/post_controls.dart';
import 'package:html_unescape/html_unescape.dart';

import 'comment_list_item.dart';

class DesktopCommentsScreen extends StatelessWidget {
  final PostsFeedDataChildrenData postData;
  static final _unescape = HtmlUnescape();
  DesktopCommentsScreen({@required this.postData});

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
                pinned: true,
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
                              launchURL(
                                  Theme.of(context).primaryColor, postData.url);
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
//                                String _htmlContent = _unescape
//                                    .convert(commentItem.data.bodyHtml);
//                                return ListTile(
//                                  title: Row(
//                                    children: <Widget>[
//                                      SizedBox(
//                                        width: commentItem.data.depth * 16.0,
//                                      ),
//                                      Html(
//                                        data: commentItem.data.bodyHtml,
//                                        useRichText: false,
//                                      ),
//                                    ],
//                                  ),
//                                );
                              return CommentItem(
                                commentItem,
                                postData.name,
                                postData.id,
                                index,
                              );
//                                return ListTile(
//                                  title: Html(
//                                    padding: EdgeInsets.all(0),
//                                    defaultTextStyle:
//                                        Theme.of(context).textTheme.bodyText2,
//                                    linkStyle: Theme.of(context)
//                                        .textTheme
//                                        .bodyText2
//                                        .copyWith(
//                                          color: Theme.of(context).accentColor,
//                                        ),
//                                    data: _htmlContent,
//                                    useRichText: true,
//                                    blockSpacing: 1,
//                                    showImages: false,
//                                    renderNewlines: false,
//                                    onLinkTap: (url) {
//                                      if (url.startsWith("/r/") ||
//                                          url.startsWith("r/")) {
//                                        Navigator.push(
//                                          context,
//                                          CupertinoPageRoute(
//                                            fullscreenDialog: false,
//                                            builder: (BuildContext context) {
//                                              return SubredditFeedPage(
//                                                  subreddit:
//                                                      url.startsWith("/r/")
//                                                          ? url.replaceFirst(
//                                                              "/r/", "")
//                                                          : url.replaceFirst(
//                                                              "r/", ""));
//                                            },
//                                          ),
//                                        );
//                                      } else if (url.startsWith("/u/") ||
//                                          url.startsWith("u/")) {
//                                      } else {
//                                        launchURL(Theme.of(context).primaryColor, url);
//                                      }
//                                    },
//                                  ),
//                                );
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
