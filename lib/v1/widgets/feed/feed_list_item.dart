import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/helpers/media_type_enum.dart';
import 'package:fritter_for_reddit/v1/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/v1/pages/photo_viewer_screen.dart';
import 'package:fritter_for_reddit/v1/widgets/feed/reddit_video_player.dart';
import 'package:html_unescape/html_unescape.dart';

import 'post_url_preview.dart';

class FeedCard extends StatelessWidget {
  final PostsFeedDataChildrenData? data;

  FeedCard(this.data);

  final _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FeedCardTitle(
          title: data!.title!,
          stickied: data!.stickied,
          linkFlairText: data!.linkFlairText,
          nsfw: data!.over18,
          locked: data!.locked,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'in r/' + data!.subreddit! + ' by ' + data!.author!,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
        ),
        if (data!.postType == MediaType.Url)
          PostUrlPreview(
            data: data,
            htmlUnescape: _htmlUnescape,
          ),
        if (data!.hasPreview)
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
            child: FeedCardBodyImage(
              images: data!.preview!.images!,
              data: data,
              postMetaData: {'media_type': data!.postType, 'url': data!.url},
              deviceWidth: MediaQuery.of(context).size.width,
            ),
          ),
      ],
    );
  }
}

class FeedCardTitle extends StatelessWidget {
  final String title;
  final bool? stickied;
  final String? linkFlairText;
  final bool? nsfw;
  final bool? locked;

  final String escapedTitle;

  FeedCardTitle({
    required this.title,
    required this.stickied,
    required this.linkFlairText,
    required this.nsfw,
    required this.locked,
  }) : escapedTitle = HtmlUnescape().convert(title);

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
          Text(
            title,
          ),
          SizedBox(
            height: 4.0,
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
//                    style: Theme.of(context).textTheme.subtitle2,
//                  ),
//                )
//              : Container(),
        ],
      ),
    );
  }
}

class FeedCardBodyImage extends StatelessWidget {
  final Map<String, dynamic> postMetaData;
  final List<PostsFeedDataChildDataPreviewImages> images;
  final PostsFeedDataChildrenData? data;
  final double deviceWidth;
  static final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  final String? url;
  final double ratio;

  FeedCardBodyImage({
    required this.images,
    required this.data,
    required this.postMetaData,
    required this.deviceWidth,
  })  : url = images.isNotEmpty
            ? _htmlUnescape.convert(images.first.source!.url!)
            : null,
        ratio = (deviceWidth) / images.first.source!.width!,
        assert(postMetaData != null);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
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
                  postMetaData['media_type'] == MediaType.Video
                      ? RedditVideoPlayer(uri: postMetaData['url'])
                      : CachedNetworkImage(
                          placeholder: (context, url) => Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                              width: deviceWidth,
                              height: 100
//                                images.first.source.height.toDouble() * ratio,
                              ),
                          imageUrl: postMetaData['url'],
//                          width: deviceWidth,
//                          height: images.first.source.height.toDouble() * ratio,
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
  final String? selftextHtml;

  FeedCardBodySelfText({this.selftextHtml});

  final HtmlUnescape _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Html(
      data: """${_htmlUnescape.convert(selftextHtml!)}""",
      onLinkTap: (url, _, __, ___) {
        if (url!.startsWith("/r/") || url.startsWith("r/")) {
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
          launchURL(Theme.of(context).primaryColor, url);
        }
      },
    );
  }
}

class StickyTag extends StatelessWidget {
  final bool? _isStickied;

  StickyTag(this._isStickied);

  @override
  Widget build(BuildContext context) {
    return _isStickied!
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
