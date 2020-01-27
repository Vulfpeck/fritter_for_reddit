import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/models/postsfeed/posts_feed_entity.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../exports.dart';

class PostUrlPreview extends StatelessWidget {
  const PostUrlPreview({
    Key key,
    @required this.data,
    @required this.htmlUnescape,
  }) : super(key: key);

  final PostsFeedDataChildrenData data;
  final HtmlUnescape htmlUnescape;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 12.0,
        bottom: 4.0,
      ),
      child: Container(
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Theme.of(context).accentColor.withOpacity(0.1),
        ),
        child: ListTile(
          dense: true,
          onTap: () {
            launchURL(context, data.url);
          },
          title: Text(
            data.url,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: Theme.of(context).textTheme.subtitle.color.withOpacity(
                        0.8,
                      ),
                ),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
          ),
          trailing: data.preview != null
              ? CircleAvatar(
                  radius: 16,
                  backgroundImage: CachedNetworkImageProvider(
                    htmlUnescape.convert(
                      data.preview.images.last.source.url,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 16,
                  child: Icon(
                    Icons.link,
                    color: Colors.white,
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                ),
        ),
      ),
    );
  }
}
