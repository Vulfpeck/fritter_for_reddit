import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/providers/comments_provider.dart';
import 'package:flutter_provider_app/widgets/comments/comment_list_item.dart';
import 'package:flutter_provider_app/widgets/comments/comments_bar.dart';
import 'package:flutter_provider_app/widgets/feed/feed_list_item.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';

class CommentsSheet extends StatelessWidget {
  final PostsFeedDataChildrenData item;
  CommentsSheet(this.item);

  @override
  Widget build(BuildContext context) {
    print("Post id is " + item.name);
    return Hero(
      tag: item.id,
      child: Dismissible(
        direction: DismissDirection.startToEnd,
        movementDuration: Duration(milliseconds: 450),
        background: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
          ),
        ),
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        key: Key("test"),
        child: Consumer(
          builder: (BuildContext context, CommentsProvider model, _) {
            return Scaffold(
              body: Material(
                color: Theme.of(context).cardColor,
                child: CustomScrollView(
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
                      leading: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: false).pop();
                        },
                      ),
                    ),
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
                                  print('tap tap');
                                  if (item.isSelf == false) {
                                    print(item.url);
                                    launchURL(context, item.url);
                                  }
                                },
                                child: FeedCard(item),
                              ),
                            ),
                            item.isSelf &&
                                    item.preview == null &&
                                    item.selftextHtml != null
                                ? FeedCardBodySelfText(
                                    selftextHtml: item.selftextHtml,
                                  )
                                : Container(),
                            PostControls(item),
                            Divider(),
                            CommentsControlBar(item),
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
                          : model.commentsMap[item.id] == null ||
                                  model.commentsMap[item.id].length == 0
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
                                    var commentItem = model.commentsMap[item.id]
                                        .elementAt((index));
                                    return CommentItem(
                                      commentItem,
                                      item.name,
                                      item.id,
                                      index,
                                    );
                                  },
                                  childCount: model.commentsMap[item.id].length,
                                ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 150,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
