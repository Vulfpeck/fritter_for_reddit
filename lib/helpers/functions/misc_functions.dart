import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';

import '../media_type_enum.dart';

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
          result['url'] = data.preview.images.first.source.url;
          return result;
        } else {
          result['media_type'] = MediaType.Video;
          String url = data.media['reddit_video']['fallback_url']
              .toString()
              .replaceFirstMapped(RegExp(r'DASH_\d+'), (match) {
            return 'DASH_240';
          });
          result['url'] = url;
          return result;
        }
        break;
      }
    case false:
      {
        if (data.media == null) {
          final Uri uri = Uri.parse(data.url);
          if (uri.authority == 'imgur.com' ||
              uri.authority == 'i.imgur.com' ||
              uri.authority == 'm.imgur.com') {
            if (uri.path.contains('/a/') || uri.path.contains('/gallery')) {
              result['media_type'] = MediaType.ImgurGallery;
              result['url'] = data.url;
              return result;
            } else if (uri.path.contains('mp4') || uri.path.contains('gifv')) {
              result['media_type'] = MediaType.Video;
              result['url'] = data.url.replaceAll('gifv', 'mp4');
              return result;
            } else if (data.preview.images.first.variants.toJson()["mp4"] != null){
              result['media_type'] = MediaType.Video;
              result['url'] = data.preview.images.first.variants.toJson()["mp4"]["source"]["url"];
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

  return {'media_type': MediaType.Url, 'url': data.url};
}
