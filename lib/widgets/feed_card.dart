import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';

class FeedCardImage extends StatelessWidget {
  final String _thumbnail, _title;
  final int height;

  FeedCardImage(this._thumbnail, this._title, this.height);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Text(
              _title,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Image.network(
            _thumbnail.toString().replaceAll('amp;s', 's'),
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class FeedCardSelfText extends StatelessWidget {
  PostsFeedDataChildrenData _data;

  FeedCardSelfText(this._data);

  @override
  Widget build(BuildContext context) {
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(_data.selftext);

    String selfText = "";
    for (int i = 0; i < 10 && i < lines.length; i++) {
      selfText += lines.elementAt(i);
    }
    return Card(
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Text(
              _data.title,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
            child: Text(
              selfText,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
