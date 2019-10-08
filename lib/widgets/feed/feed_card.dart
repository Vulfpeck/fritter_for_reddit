import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

class FeedCardImage extends StatelessWidget {
  final PostsFeedDataChildrenData _data;

  FeedCardImage(this._data);

  final HtmlUnescape _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final ratio = (mq.width - 16) / _data.preview.images.first.source.width;
    final url = _htmlUnescape.convert(_data.preview.images.first.source.url);
    return Consumer(builder: (BuildContext context, FeedProvider model, _) {
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image(
                  image: CachedNetworkImageProvider(
                    url,
                  ),
                  fit: BoxFit.fitWidth,
                  height: _data.preview.images.first.source.height.toDouble() *
                      ratio,
                ),
              ),
            ),
            PostControls(_data),
          ],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );
    });
  }
}

class FeedCardSelfText extends StatelessWidget {
  final PostsFeedDataChildrenData _data;
  final _expandSelfText;
  final HtmlUnescape unescape = new HtmlUnescape();
  FeedCardSelfText(this._data, this._expandSelfText);

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
          _data.selftext != ""
              ? Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 4.0, left: 16.0, right: 16.0),
                  child: Text(
                    _expandSelfText ? _data.selftext : selfText,
                    style: Theme.of(context).textTheme.body2,
                  ),
                )
              : Container(),
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
