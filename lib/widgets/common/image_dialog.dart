import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/widgets/common/gallery_card.dart';

class ImageDialog extends StatefulWidget {
  const ImageDialog({
    Key key,
    @required this.postFeedItem,
  }) : super(key: key);

  final PostsFeedDataChild postFeedItem;

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  double height = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        height = 100;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 4),
      height: height,
      child: AlertDialog(
        title: Text(
          widget.postFeedItem.title,
          softWrap: true,
        ),
        content: Card(
          child: SizedBox(
            child: GalleryImage(
              postFeedItem: widget.postFeedItem,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.file_download,
            ),
            onPressed: () {},
            label: Text('Download'),
          ),
          FlatButton.icon(
            icon: Icon(
              Icons.share,
            ),
            onPressed: () {},
            label: Text('Share'),
          ),
        ],
      ),
    );
  }
}
