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
  final PostsFeedDataChildrenData postItem;
  static final _unescape = HtmlUnescape();
  CommentsScreen({@required this.postItem});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CommentsProvider model, _) {
        return Scaffold(
          body: Material(
            color: Theme.of(context).cardColor,
            child: CustomScrollView(
              cacheExtent: 200,
            
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
                        SizedBox(
                          height: 16.0,
                        ),
                        Material(
                          color: Theme.of(context).cardColor,
                          child: InkWell(
                            onTap: () {
                              if (postItem.isSelf == false) {
                                launchURL(context, postItem.url);
                              }
                            },
                            child: FeedCard(postItem),
                          ),
                        ),
                        postItem.isSelf && postItem.selftextHtml != null
                            ? FeedCardBodySelfText(
                                selftextHtml: postItem.selftextHtml,
                              )
                            : Container(),
                        PostControls(
                          postData: postItem,
                        ),
                        Divider(),
                        CommentsControlBar(postItem),
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
                      : model.commentsMap[postItem.id] == null ||
                              model.commentsMap[postItem.id].length == 0
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
                                    model.commentsMap[postItem.id].elementAt(
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
                                  postItem.name,
                                  postItem.id,
                                  index,
                                );
//                                return ListTile(
//                                  title: Html(
//                                    padding: EdgeInsets.all(0),
//                                    defaultTextStyle:
//                                        Theme.of(context).textTheme.body1,
//                                    linkStyle: Theme.of(context)
//                                        .textTheme
//                                        .body1
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
//                                        launchURL(context, url);
//                                      }
//                                    },
//                                  ),
//                                );
                              },
                              childCount: model.commentsMap[postItem.id].length,
                              addAutomaticKeepAlives: true,
                          
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
            ),
          ),
        );
      },
    );
  }
}
