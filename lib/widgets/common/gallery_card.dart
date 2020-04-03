import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';

class GalleryImage extends StatelessWidget {
  final BoxFit fit;
  const GalleryImage({
    Key key,
    @required this.postFeedItem,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final PostsFeedDataChild postFeedItem;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: fit,
      imageUrl:
          postFeedItem.data.preview.images.first.source.url.asSanitizedImageUrl,
      errorWidget: (context, url, error) {
        return CachedNetworkImage(
          fit: fit,
          imageUrl: postFeedItem.data.thumbnail.asSanitizedImageUrl,
          errorWidget: (context, url, error) {
            return Icon(Icons.broken_image);
          },
        );
      },
    );
  }
}

enum ImageQuality { lowest, highest }

//fixed code when extended_image updates
//return ConditionalBuilder(
//condition: _extended,
//builder: (context) => CachedNetworkImage(
//fit: fit,
//imageUrl: postFeedItem
//    .data.preview.images.first.source.url.asSanitizedImageUrl,
//errorWidget: (context, url, error) {
//return CachedNetworkImage(
//fit: fit,
//imageUrl: postFeedItem.data.thumbnail.asSanitizedImageUrl,
//errorWidget: (context, url, error) {
//return Icon(Icons.broken_image);
//},
//);
//},
//),
//fallback: (context) {
//try {
//return ExtendedImage.network(
//postFeedItem
//    .data.preview.images.first.source.url.asSanitizedImageUrl,
//fit: fit,
//);
//} catch (e) {
//return ExtendedImage.network(
//postFeedItem.data.thumbnail.asSanitizedImageUrl,
//fit: fit,
//);
//}
//});
