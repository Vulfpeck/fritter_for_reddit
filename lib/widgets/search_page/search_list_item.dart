import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_provider_app/exports.dart';
import 'package:flutter_provider_app/models/search_results/posts/search_posts_repo_entity_entity.dart';
import 'package:flutter_provider_app/pages/photo_viewer_screen.dart';
import 'package:html_unescape/html_unescape.dart';

class SearchCard extends StatelessWidget {
  final SearchPostsRepoEntityDataChildrenData data;
  SearchCard(this.data);

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
            child: SearchCardTitle(
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
                      child: SearchCardBodyImage(
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

class SearchCardTitle extends StatelessWidget {
  final String title;
  final bool stickied;
  final String linkFlairText;
  final bool nsfw;

  SearchCardTitle({
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
          SearchStickyTag(stickied),
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

class SearchCardBodyImage extends StatelessWidget {
  final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  final List<SearchPostsRepoEntityDatachildDataPreviewImages> images;
  final SearchPostsRepoEntityDataChildrenData data;

  SearchCardBodyImage({@required this.images, @required this.data});

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
                print("media : " + data.media.toString());
                if (data.media != null) {
                  String videoUrl = getMediaUrl(data);
                  bool isVideo = videoUrl != null && videoUrl.contains("mp4");
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(
                    CupertinoPageRoute(
                      builder: (BuildContext context) {
                        return PhotoViewerScreen(
                          mediaUrl: videoUrl == null ? url : videoUrl,
                          isVideo: isVideo,
                        );
                      },
                      fullscreenDialog: true,
                    ),
                  );
                } else {
                  if (data.isRedditMediaDomain) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).push(
                      CupertinoPageRoute(
                        builder: (BuildContext context) {
                          return PhotoViewerScreen(
                            mediaUrl: url,
                            isVideo: false,
                          );
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  } else {
                    launchURL(context, data.url);
                  }
                }
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
//                height: images.first.source.height.toDouble() * ratio ,
                width: mq.width,
                height: images.first.source.height >= 500
                    ? 500.0
                    : images.first.source.height.toDouble(),
              ),
            ),
          ),
        );
      },
    );
  }

  String getMediaUrl(SearchPostsRepoEntityDataChildrenData data) {
    String url;
    if (data.media != null) {
      if (data.media['reddit_video'] != null) {
        print("reddit video");
      } else if (data.media['oembed']['provider_url'] != null) {
        String subType = data.media['oembed']['provider_url'];
        if (subType == "http://imgur.com") {
          print("imgur thing");
          if (!data.media['oembed']['url'].toString().contains('/a/')) {
            print("Imgur url" + data.media['oembed']['url']);
          }
        } else if (subType == "https://gfycat.com") {
          print('gfycat');
          url = data.media['oembed']['thumbnail_url']
              .toString()
              .replaceAll(".gif", ".mp4")
              .replaceAll("thumbs", "giant")
              .replaceAll("-size_restricted", "");
        }
      } else {
        print("other");
      }
    }
    print("Final media url" + url.toString());
    return url;
  }
}

class SearchBodySelfText extends StatelessWidget {
  final String selftextHtml;
  SearchBodySelfText({this.selftextHtml});
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

class SearchStickyTag extends StatelessWidget {
  final bool _isStickied;

  SearchStickyTag(this._isStickied);

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
