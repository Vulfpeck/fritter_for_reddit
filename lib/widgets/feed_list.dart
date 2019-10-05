import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/widgets/feed_card.dart';
import 'package:flutter_provider_app/widgets/translucent_app_bar.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
        builder: (BuildContext context, FeedProvider model, _) {
      return CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPersistentHeader(
            floating: true,
            pinned: false,
            delegate:
                TranslucentSliverAppDelegate(MediaQuery.of(context).padding),
          ),
          SliverList(
            delegate: model.state == ViewState.Idle &&
                    Provider.of<UserInformationProvider>(context).state ==
                        ViewState.Idle
                ? SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var item = model.postFeed.data.children[index].data;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return CommentsSheet();
                                });
                          },
                          child: item.isSelf == false && item.preview != null
                              ? FeedCardImage(item)
                              : FeedCardSelfText(item),
                        ),
                      );
                    },
                    childCount: model.postFeed.data.children.length,
                  )
                : SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
          )
        ],
      );
    });
  }
}

class CommentsSheet extends StatefulWidget {
  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 1.0,
      minChildSize: 0.2,
      initialChildSize: 0.8,
      expand: false,
      builder: (BuildContext context, ScrollController controller) {
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            return ListTile(
              title: Text('fuck'),
            );
          },
          controller: controller,
        );
      },
    );
  }
}
