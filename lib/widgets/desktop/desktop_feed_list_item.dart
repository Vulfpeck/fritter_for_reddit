import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/helpers/functions/hex_to_color_class.dart';
import 'package:fritter_for_reddit/helpers/media_type_enum.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/pages/photo_viewer_screen.dart';
import 'package:fritter_for_reddit/widgets/common/expansion_tile.dart';
import 'package:fritter_for_reddit/widgets/feed/post_url_preview.dart';
import 'package:fritter_for_reddit/widgets/feed/reddit_video_player.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';

class DesktopFeedCard extends StatelessWidget {
  final PostsFeedDataChildrenData post;

  DesktopFeedCard({@required this.post});

  final _htmlUnescape = new HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: post.hasPreview,
      builder: (_) => RestrictedExpansionTile(
        leading: Card(
          child: CachedNetworkImage(
            imageUrl: post.previewUrl,
            width: 50,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => ErrorWidget(url),
          ),
        ),
        title: FeedCardTitle(
          title: post.title,
          stickied: post.stickied,
          linkFlairText: post.linkFlairText,
          nsfw: post.over18,
          locked: post.locked,
          author: post.author,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (post.over18)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 15,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'NSFW',
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (post.isSelf == false && post.postType == MediaType.Url)
            PostUrlPreview(
              data: post,
              htmlUnescape: _htmlUnescape,
            ),
          if (post.preview != null &&
              post.isSelf == false &&
              post.postType != MediaType.Url)
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
              child: FeedCardBodyImage(
                images: post.preview.images,
                data: post,
                postMetaData: {'media_type': post.postType, 'url': post.url},
                deviceWidth: MediaQuery.of(context).size.width,
              ),
            ),
        ],
      ),
      fallback: (_) => ListTile(
        leading: Card(
          child: ConditionalBuilder(
            condition: post.linkFlairText != null,
            builder: (_) => Chip(
              label: Text(post.linkFlairText),
              backgroundColor: HexColor(post.linkFlairBackgroundColor),
            ),
            fallback: (_) => Icon(
              Icons.message,
              size: 60,
            ),
          ),
        ),
        title: FeedCardTitle(
          title: post.title,
          stickied: post.stickied,
          linkFlairText: post.linkFlairText,
          nsfw: post.over18,
          locked: post.locked,
          author: post.author,
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (post.over18)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                            size: 15,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            'NSFW',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
            post.isSelf == false && post.postType == MediaType.Url
                ? PostUrlPreview(
                    data: post,
                    htmlUnescape: _htmlUnescape,
                  )
                : Container(),
            post.preview != null &&
                    post.isSelf == false &&
                    post.postType != MediaType.Url
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 0.0, top: 16.0),
                    child: FeedCardBodyImage(
                      images: post.preview.images,
                      data: post,
                      postMetaData: {
                        'media_type': post.postType,
                        'url': post.url
                      },
                      deviceWidth: MediaQuery.of(context).size.width,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class FeedCardTitle extends StatelessWidget {
  final String title;
  final bool stickied;
  final String linkFlairText;
  final bool nsfw;
  final bool locked;
  final String author;
  final bool isCrossPost;

  final String escapedTitle;

  FeedCardTitle({
    @required this.title,
    @required this.stickied,
    @required this.linkFlairText,
    @required this.nsfw,
    @required this.locked,
    @required this.author,
    this.isCrossPost = false,
  }) : escapedTitle = HtmlUnescape().convert(title);

  String get postSuffix => isCrossPost ? 'Crossposted' : 'Posted';

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
          Text(
            '$postSuffix by u/$author',
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 12, color: Colors.grey),
          ),
          StickyTag(stickied),
          Text(
            title.htmlUnescaped,
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
  final PostsFeedDataChildrenData data;
  final double deviceWidth;
  static final HtmlUnescape _htmlUnescape = new HtmlUnescape();
  final String url;
  final double ratio;

  FeedCardBodyImage({
    @required this.images,
    @required this.data,
    @required this.postMetaData,
    @required this.deviceWidth,
  })  : url = _htmlUnescape.convert(
          images.first.source.url,
        ),
        ratio = (deviceWidth) / images.first.source.width,
        assert(postMetaData != null);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, FeedProvider model, _) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (postMetaData['media_type'] == MediaType.Video ||
                    postMetaData['media_type'] == MediaType.Image) {
                  Navigator.of(
                    context,
                    rootNavigator: false,
                  ).push(
                    CupertinoPageRoute(
                      maintainState: true,
                      builder: (BuildContext context) {
                        return PhotoViewerScreen(
                          mediaUrl: postMetaData['media_type'] ==
                                  MediaType.Image
                              ? _htmlUnescape.convert(images.first.source.url)
                              : postMetaData['url'],
                          isVideo:
                              postMetaData['media_type'] == MediaType.Video,
                        );
                      },
                      fullscreenDialog: false,
                    ),
                  );
                } else {}
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => PhotoViewerScreen(
                    fullScreen: false,
                    mediaUrl: postMetaData['media_type'] == MediaType.Image
                        ? _htmlUnescape.convert(images.first.source.url)
                        : postMetaData['url'],
                    isVideo: postMetaData['media_type'] == MediaType.Video,
                  ),
                );
              },
              child: postMetaData['media_type'] == MediaType.Video
                  ? RedditVideoPlayer(uri: postMetaData['url'])
                  : CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                      imageUrl:
                          (postMetaData['url'] as String).asSanitizedImageUrl,
                      fadeOutDuration: Duration(milliseconds: 300),
                      errorWidget: (context, url, error) => ErrorWidget(url),
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
      defaultTextStyle: Theme.of(context).textTheme.bodyText2,
      linkStyle: Theme.of(context).textTheme.bodyText2.copyWith(
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
          launchURL(Theme.of(context).primaryColor, url);
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
