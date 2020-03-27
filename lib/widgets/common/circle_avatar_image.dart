import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleAvatarImage extends StatelessWidget {
  final String imageUrl;
  final Color backgroundColor;

  const CircleAvatarImage({
    Key key,
    @required this.imageUrl,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 16,
      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImageProvider(imageUrl)
          : AssetImage('assets/default_icon.png'),
      backgroundColor: backgroundColor ?? Theme.of(context).accentColor,
    );
  }
}
