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
              linkFlairText: data.linkFlairText,
              nsfw: data.over18,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'in '),
                  TextSpan(
                    text: "r/" + data.subreddit,
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  TextSpan(text: " by "),
                  TextSpan(
                    text: "u/" + data.author + " ",
                    style: Theme.of(context).textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
              child: data.preview != null && data.isSelf == false
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
                      child: FeedCardBodyImage(
                        images: data.preview.images,
                        data: data,
                      ),
                    )
                  : Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedCardTitle extends StatelessWidget {
  final String title;
  final bool stickied;
  final String linkFlairText;
  final bool nsfw;

  FeedCardTitle({
    @required this.title,
    @required this.stickied,
    @required this.linkFlairText,
    @required this.nsfw,
  });

  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
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
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: _htmlUnescape.convert(title) + "  ",
                    style: Theme.of(context).textTheme.title,
                  ),
                ],
              ),
            ),
          ),
          nsfw == true || linkFlairText != null
              ? RichText(
                  textScaleFactor: 0.9,
                  text: TextSpan(
                    children: <TextSpan>[
                      nsfw != null && nsfw
                          ? TextSpan(
                              text: "NSFW ",
                              style: TextStyle(
                                color: Colors.red.withOpacity(
                                  0.9,
                                ),
                              ),
                            )
                          : TextSpan(),
                      linkFlairText != null
                          ? TextSpan(
                              text: linkFlairText,
                              style:
                                  Theme.of(context).textTheme.subtitle.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle
                                            .color
                                            .withOpacity(0.8),
                                      ),
                            )
                          : TextSpan(),
                    ],
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class FeedCardBodyImage extends StatelessWidget {
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  final List<PostsFeedDatachildDataPreviewImages> images;
  final PostsFeedDataChildrenData data;

  FeedCardBodyImage({@required this.images, @required this.data});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final double ratio = (mq.width) / images.first.source.width;
    String url = _htmlUnescape.convert(images.first.source.url);

    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Map<String, dynamic> result = getMediaType(data);
                if (result['media_type'] == MediaType.Video ||
                    result['media_type'] == MediaType.Image) {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(
                    CupertinoPageRoute(
                      builder: (BuildContext context) {
                        return PhotoViewerScreen(
                          mediaUrl: result['media_type'] == MediaType.Image
                              ? url
                              : result['url'],
                          isVideo: result['media_type'] == MediaType.Video,
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
                  Image(
                image: CachedNetworkImageProvider(
                  url,
                ),
                fit: BoxFit.fitWidth,
                width: mq.width,
                height: images.first.source.height.toDouble() * ratio,
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, dynamic> getMediaType(PostsFeedDataChildrenData data) {
    Map<String, dynamic> result = Map();
    if (data.isRedditMediaDomain == null) {
      data.isRedditMediaDomain = false;
    }
    switch (data.isRedditMediaDomain) {
      case true:
        {
          if (data.media == null) {
            result['media_type'] = MediaType.Image;
            result['url'] = data.url;
            return result;
          } else {
            print(data.media);
            result['media_type'] = MediaType.Video;
            String url = data.media['reddit_video']['fallback_url']
                .toString()
                .replaceFirstMapped(RegExp(r'DASH_\d+'), (match) {
              print(match.start);
              print(match.end);
              return 'DASH_240';
            });
            result['url'] = url;
            print("URLLLLLL" + url);
            return result;
          }
          break;
        }
      case false:
        {
          if (data.media == null) {
            final Uri uri = Uri.parse(data.url);
            print(uri);
            print(uri.authority);
            if (uri.authority == 'imgur.com' ||
                uri.authority == 'i.imgur.com' ||
                uri.authority == 'm.imgur.com') {
              print("imgur domain");
              if (uri.path.contains('/a/') || uri.path.contains('/gallery')) {
                result['media_type'] = MediaType.ImgurGallery;
                result['url'] = data.url;
                return result;
              } else if (uri.path.contains('mp4') ||
                  uri.path.contains('gifv')) {
                result['media_type'] = MediaType.Video;
                result['url'] = data.url.replaceAll('gifv', 'mp4');
                return result;
              } else {
                result['media_type'] = MediaType.Image;
                result['url'] = data.url;
                return result;
              }
            }
          } else {
            final Uri uri = Uri.parse(data.url);
            if (uri.authority == 'gfycat.com') {
              result['url'] = data.media['oembed']['thumbnail_url']
                  .toString()
                  .replaceAll(".gif", ".mp4")
                  .replaceAll("thumbs", "giant")
                  .replaceAll("-size_restricted", "");
              result['media_type'] = MediaType.Video;
              return result;
            } else {
              result['media_type'] = MediaType.Url;
              result['url'] = data.url;
              return result;
            }
          }
          break;
        }
    }
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
      useRichText: true,
      onLinkTap: (url) {
        if (url.startsWith("/r/") || url.startsWith("r/")) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
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
            padding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
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
