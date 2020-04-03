import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/widgets/common/gallery_card.dart';
import 'package:fritter_for_reddit/widgets/common/title_overlay.dart';

class PhotoGrid extends StatefulWidget {
  final PostsFeedEntity postsFeed;

  const PhotoGrid({
    Key key,
    @required this.postsFeed,
  }) : super(key: key);

  @override
  _PhotoGridState createState() => _PhotoGridState();
}

class _PhotoGridState extends State<PhotoGrid> {
  ScrollController _controller = ScrollController();
  GlobalKey gridKey = GlobalKey();

  List<PostsFeedDataChild> get postsWithImages =>
      widget.postsFeed.children.where((post) => post.data.hasPreview).toList();

  @override
  void didUpdateWidget(PhotoGrid oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final state = gridKey.currentState;
      return;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (postsWithImages.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.of(context).size.height - 20,
          alignment: Alignment.center,
          child: Text('No images found'),
        ),
      );
    }
    return SliverGrid.extent(
        key: gridKey,
        maxCrossAxisExtent: 200,
        children: <Widget>[
          for (final postFeedItem in postsWithImages)
            Card(
              elevation: 3,
              child: TitleOverlay(
                title: postFeedItem.title,
                child: GestureDetector(
                  child: GalleryImage(postFeedItem: postFeedItem),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ImageDialog(postFeedItem: postFeedItem);
                        });
                  },
                ),
              ),
            )
        ]);
  }
}

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
        title: Flexible(
          child: Text(
            widget.postFeedItem.title,
            softWrap: true,
          ),
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
