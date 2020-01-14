import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class PhotoViewerScreen extends StatelessWidget {
  final String mediaUrl;
  final bool isVideo;

  PhotoViewerScreen({@required this.mediaUrl, @required this.isVideo})
      : assert(mediaUrl != null),
        assert(isVideo != null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isVideo
          ? VideoPlaySection(
              url: mediaUrl,
            )
          : PhotoView(
              imageProvider: CachedNetworkImageProvider(
                mediaUrl,
              ),
            ),
    );
  }
}

class VideoPlaySection extends StatefulWidget {
  final String url;

  VideoPlaySection({@required this.url}) : assert(url != null);

  @override
  _VideoPlaySectionState createState() => _VideoPlaySectionState();
}

class _VideoPlaySectionState extends State<VideoPlaySection> {
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      widget.url,
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(_controller),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
