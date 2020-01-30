import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/helpers/media_type_enum.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:flutter_provider_app/pages/photo_viewer_screen.dart';
import 'package:html_unescape/html_unescape.dart';

import 'post_url_preview.dart';

class FeedCard extends StatelessWidget {
  final PostsFeedDataChildrenData data;

  FeedCard(this.data);
  final _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FeedCardTitle(
          title: data.title,
          stickied: data.stickied,
          linkFlairText: data.linkFlairText,
          nsfw: data.over18,
          locked: data.locked,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            'in r/' + data.subreddit + ' by ' + data.author,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        data.isSelf == false && data.postType == MediaType.Url
            ? PostUrlPreview(
                data: data,
                htmlUnescape: _htmlUnescape,
              )
            : Container(),
        data.preview != null &&
                data.isSelf == false &&
                data.postType != MediaType.Url
            ? Padding(
                padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
                child: FeedCardBodyImage(
                  images: data.preview.images,
                  data: data,
                  postMetaData: {'media_type': data.postType, 'url': data.url},
                  deviceWidth: MediaQuery.of(context).size.width,
                ),
              )
            : Container(),
      ],
    );
  }
}

class FeedCardTitle extends StatelessWidget {
  final String title;
  final bool stickied;
  final String linkFlairText;
  final bool nsfw;
  final bool locked;

  final HtmlUnescape _htmlUnescape = new HtmlUnescape();

  String escapedTitle;
  FeedCardTitle({
    @required this.title,
    @required this.stickied,
    @required this.linkFlairText,
    @required this.nsfw,
    @required this.locked,
  }) {
//    escapedTitle = _htmlUnescape.convert(title);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 4.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StickyTag(stickied),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(title),
          ),
//          nsfw == true || linkFlairText != null
//              ? RichText(
//                  textScaleFactor: 0.9,
//                  text: TextSpan(
//                    children: <TextSpan>[
//                      nsfw != null && nsfw
//                          ? TextSpan(
//                              text: "NSFW ",
//                              style: TextStyle(
//                                color: Colors.red.withOpacity(
//                                  0.9,
//                                ),
//                              ),
//                            )
//                          : TextSpan(),
//                      linkFlairText != null
//                          ? TextSpan(
//                              text: linkFlairText,
//                              style: Theme.of(context)
//                                  .textTheme
//                                  .subtitle
//                                  .copyWith(
//                                      color: Theme.of(context)
//                                          .textTheme
//                                          .subtitle
//                                          .color
//                                          .withOpacity(0.8),
//                                      backgroundColor: Theme.of(context)
//                                          .textTheme
//                                          .subtitle
//                                          .color
//                                          .withOpacity(0.15),
//                                      decorationThickness: 2),
//                            )
//                          : TextSpan(),
//                    ],
//                    style: Theme.of(context).textTheme.subtitle,
//                  ),
//                )
//              : Container(),
        ],
      ),
    );
  }
}

class FeedCardBodyImage extends StatefulWidget {
  final Map<String, dynamic> postMetaData;
  final List<PostsFeedDatachildDataPreviewImages> images;
  final PostsFeedDataChildrenData data;
  final double deviceWidth;

  FeedCardBodyImage({
    @required this.images,
    @required this.data,
    @required this.postMetaData,
    @required this.deviceWidth,
  }) : assert(postMetaData != null);

  @override
  _FeedCardBodyImageState createState() => _FeedCardBodyImageState();
}

class _FeedCardBodyImageState extends State<FeedCardBodyImage> {
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  String url = "";
  double ratio = 1;
  @override
  void initState() {
    /// this is to select the best quality image
    // TODO: Try to do this while parsing the json
    ratio = (widget.deviceWidth) / widget.images.first.source.width;
    url = _htmlUnescape.convert(widget.images.first.resolutions
        .elementAt(widget.images.first.resolutions.length ~/ 2)
        .url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (widget.postMetaData['media_type'] == MediaType.Video ||
                    widget.postMetaData['media_type'] == MediaType.Image) {
                  Navigator.of(
                    context,
                    rootNavigator: false,
                  ).push(
                    CupertinoPageRoute(
                      maintainState: true,
                      builder: (BuildContext context) {
                        return PhotoViewerScreen(
                          mediaUrl: widget.postMetaData['media_type'] ==
                                  MediaType.Image
                              ? _htmlUnescape
                                  .convert(widget.images.first.source.url)
                              : widget.postMetaData['url'],
                          isVideo: widget.postMetaData['media_type'] ==
                              MediaType.Video,
                        );
                      },
                      fullscreenDialog: true,
                    ),
                  );
                } else {}
              },
              child:
//            data.media != null
//                ? Image(
//                    image: CachedNetworkImageProvider(
//                        data.media['oembed']['thumbnail_url']),
//                  )
//                :

//                  Image(
//
//                image: CachedNetworkImageProvider(
//                  url,
//                ),
//                fit: BoxFit.fitWidth,
//                width: widget.deviceWidth,
//                height: widget.images.first.source.height.toDouble() * ratio,
//              ),
                  CachedNetworkImage(
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                  width: widget.deviceWidth,
                  height: widget.images.first.source.height.toDouble() * ratio,
                ),
                imageUrl: url,
                width: widget.deviceWidth,
                height: widget.images.first.source.height.toDouble() * ratio,
                fadeOutDuration: Duration(milliseconds: 300),
              ),
            ),
          ),
        );
      },
    );
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
      defaultTextStyle: Theme.of(context).textTheme.body1,
      linkStyle: Theme.of(context).textTheme.body1.copyWith(
            color: Theme.of(context).accentColor,
          ),
      padding: EdgeInsets.all(16),
      data: """${_htmlUnescape.convert(selftextHtml)}""",
      useRichText: false,
      onLinkTap: (url) {
        if (url.startsWith("/r/") || url.startsWith("r/")) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              maintainState: true,
              fullscreenDialog: false,
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.turned_in,
                    size: 12,
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.green.shade50.withOpacity(0.7)
                        : Colors.green.shade900.withOpacity(0.7),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 2, bottom: 2, left: 2, right: 4),
                    child: Text(
                      'Stickied',
                      style: TextStyle(
                          color: MediaQuery.of(context).platformBrightness ==
                                  Brightness.dark
                              ? Colors.green.shade50
                              : Colors.green.shade900,
                          fontSize: 12),
                    ),
                  ),
                ],
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
