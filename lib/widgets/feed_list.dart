import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';
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
        slivers: <Widget>[
          SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate:
                TranslucentSliverAppDelegate(MediaQuery.of(context).padding),
          ),
          SliverList(
            delegate: model.state == ViewState.Idle
                ? SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      var item = model.postFeed.data.children[index].data;
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(
                            item.subredditNamePrefixed + " | " + item.author),
                        dense: false,
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
