import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_provider/video_provider.dart';

class RedditVideoPlayer extends StatefulWidget {
  final String uri;

  RedditVideoPlayer({Key key, @required this.uri})
      : assert(uri != null),
        super(key: key);

  @override
  _RedditVideoPlayerState createState() => _RedditVideoPlayerState();
}

class _RedditVideoPlayerState extends State<RedditVideoPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Video>(
      stream: CheckedVideoProvider.fromUri(
        Uri.parse(widget.uri),
      ).getVideos(),
      builder: (BuildContext context, AsyncSnapshot<Video> snapshot) {
        final controller =
            VideoPlayerController.network(snapshot.data.uri.path);
        return VideoPlayer(controller);
      },
    );
  }
}
