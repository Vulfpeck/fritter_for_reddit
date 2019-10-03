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
            pinned: true,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: item.isSelf == false && item.preview != null
                            ? FeedCardImage(
                                item.preview.images.first.source.url,
                                item.title,
                                item.preview.images.first.source.height)
                            : FeedCardSelfText(item),
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
