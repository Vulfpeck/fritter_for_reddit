import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';
import 'package:html_unescape/html_unescape.dart';

class FeedCard extends StatefulWidget {
  final PostsFeedDataChildrenData data;
  FeedCard(this.data);
  @override
  _FeedCardState createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FeedCardTitle(
            title: widget.data.title,
            stickied: widget.data.stickied,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: widget.data.isSelf &&
                    widget.data.preview == null &&
                    widget.data.selftextHtml != null
                ? FeedCardBodySelfText(selftextHtml: widget.data.selftextHtml)
                : widget.data.preview != null
                    ? FeedCardBodyImage(widget.data.preview.images)
                    : Container(),
          ),
          PostControls(widget.data),
        ],
      ),
    );
  }
}

class FeedCardTitle extends StatefulWidget {
  final String title;
  final bool stickied;
  FeedCardTitle({this.title, this.stickied});
  @override
  _FeedCardTitleState createState() => _FeedCardTitleState();
}

class _FeedCardTitleState extends State<FeedCardTitle> {
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StickyTag(widget.stickied),
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _htmlUnescape.convert(widget.title),
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FeedCardBodyImage extends StatelessWidget {
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  final List<PostsFeedDatachildDataPreviewImages> images;

  FeedCardBodyImage(this.images);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final double ratio = (mq.width) / images.first.source.width;
    final String url = _htmlUnescape.convert(images.first.source.url);

    return Consumer(builder: (BuildContext context, FeedProvider model, _) {
      return Center(
        child: Image(
          image: CachedNetworkImageProvider(
            url,
          ),
          fit: BoxFit.fitWidth,
          height: images.first.source.height.toDouble() * ratio,
        ),
      );
    });
  }
}

class FeedCardBodySelfText extends StatefulWidget {
  final String selftextHtml;
  FeedCardBodySelfText({this.selftextHtml});

  @override
  _FeedCardBodySelfTextState createState() => _FeedCardBodySelfTextState();
}

class _FeedCardBodySelfTextState extends State<FeedCardBodySelfText> {
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Html(
      renderNewlines: true,
      defaultTextStyle: Theme.of(context).textTheme.body1,
      linkStyle: Theme.of(context).textTheme.body1.copyWith(
            color: Theme.of(context).accentColor,
          ),
      padding: EdgeInsets.all(16),
      data: """${_htmlUnescape.convert(widget.selftextHtml)}""",
      useRichText: true,
      onLinkTap: (url) {
        if (url.startsWith("/r/") || url.startsWith("r/")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return SubredditFeedPage(
                    subreddit: url.startsWith("/r/")
                        ? url.replaceFirst("/r/", "")
                        : url.replaceFirst("r/", ""));
              },
            ),
          );
        } else if (url.startsWith("/u/") || url.startsWith("u/")) {
        } else {
          print("launching web view");

          launchURL(context, url);
        }
      },
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
              color: Colors.greenAccent,
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 24.0),
          );
  }
}
