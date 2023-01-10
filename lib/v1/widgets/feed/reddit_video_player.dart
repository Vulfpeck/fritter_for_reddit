import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RedditVideoPlayer extends StatelessWidget {
  final String? uri;

  RedditVideoPlayer({
    required this.uri,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class RedditVideoPlayer extends StatefulWidget {
//   final String uri;
//
//   RedditVideoPlayer({Key key, @required this.uri})
//       : assert(uri != null),
//         super(key: key);
//
//   @override
//   _RedditVideoPlayerState createState() => _RedditVideoPlayerState();
// }
//
// class _RedditVideoPlayerState extends State<RedditVideoPlayer> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Video>(
//       stream: CheckedVideoProvider.fromUri(
//         Uri.parse(widget.uri),
//       ).getVideos(),
//       builder: (BuildContext context, AsyncSnapshot<Video> snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         final controller =
//             VideoPlayerController.network(snapshot.data.uri.path);
//         Future.delayed(Duration(seconds: 2)).then((value) => controller.play());
//         return VideoPlayer(controller);
//       },
//     );
//   }
// }
