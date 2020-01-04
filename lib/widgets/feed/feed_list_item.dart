import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/pages/photo_viewer_screen.dart';
import 'package:flutter_provider_app/widgets/feed/post_controls.dart';
import 'package:html_unescape/html_unescape.dart';

class FeedCard extends StatelessWidget {
  final PostsFeedDataChildrenData data;
  FeedCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: FeedCardTitle(
              title: data.title,
              stickied: data.stickied,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
              child: data.isSelf &&
                      data.preview == null &&
                      data.selftextHtml != null
                  ? FeedCardBodySelfText(selftextHtml: data.selftextHtml)
                  : data.preview != null
                      ? Padding(
                          padding:
                              const EdgeInsets.only(bottom: 16.0, top: 16.0),
                          child: FeedCardBodyImage(data.preview.images),
                        )
                      : Container(),
            ),
          ),
          PostControls(data),
        ],
      ),
    );
  }
}

class FeedCardTitle extends StatelessWidget {
  final String title;
  final bool stickied;
  FeedCardTitle({this.title, this.stickied});

  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        StickyTag(stickied),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
            left: 16.0,
            right: 16.0,
            top: 4.0,
          ),
          child: Text(
            _htmlUnescape.convert(title),
            style: Theme.of(context).textTheme.subhead.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 17.0,
                ),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {return PhotoViewerScreen(imageUrl: url);}));
            },
            child: Image(
              image: CachedNetworkImageProvider(
                url,
              ),
              fit: BoxFit.fitWidth,
              height: images.first.source.height.toDouble() * ratio,
            ),
          ),
        ),
      );
    });
  }
}

class FeedCardBodySelfText extends StatelessWidget {
  final String selftextHtml;
  FeedCardBodySelfText({this.selftextHtml});
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Html(
      renderNewlines: true,
      defaultTextStyle: Theme.of(context).textTheme.body1.copyWith(
          fontSize: 16,
          color: Theme.of(context).textTheme.body1.color.withOpacity(0.95)),
      linkStyle: Theme.of(context)
          .textTheme
          .body1
          .copyWith(color: Theme.of(context).accentColor, fontSize: 16),
      padding: EdgeInsets.all(16),
      data: """${_htmlUnescape.convert(selftextHtml)}""",
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
                child: Text(
                  'Stickied',
                  style: TextStyle(
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.green.shade50
                        : Colors.green.shade900,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.green.shade900
                        : Colors.green.shade100,
                borderRadius: BorderRadius.circular(
                  4.0,
                ),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 16.0),
          );
  }
}
