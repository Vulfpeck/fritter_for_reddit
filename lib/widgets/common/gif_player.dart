import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_gifimage/gif_image_info.dart';

class GifPlayer extends StatefulWidget {
  final String imageUrl;

  GifPlayer({Key key, @required this.imageUrl}) : super(key: key);

  @override
  _GifPlayerState createState() => _GifPlayerState();
}

class _GifPlayerState extends State<GifPlayer>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;

  bool get showControls => _showControls;

  set showControls(bool showControls) {
    _showControls = showControls;
    if (showControls) {
      Future.delayed(Duration(seconds: 4)).then((_) {
        setState(() {
          _showControls = false;
        });
      });
    }
  }

  GifController controller;
  Gif gif;

  int get extent => gif.imageInfo.length;

  @override
  void initState() {
    super.initState();
    fetchGif(NetworkImage(widget.imageUrl)).then((gif) {
      setState(() {
        this.gif = gif;
        controller ??= GifController(vsync: this, duration: gif.duration)
          ..repeat(min: 0, max: extent.toDouble());
      });
    });
    Future.delayed(Duration(seconds: 2)).then((_) {
      setState(() {
        showControls = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gif == null) {
      return LinearProgressIndicator();
    }

    double height = gif.height;
    double width = MediaQuery.of(context).size.width;

    final stackHeight = width / gif.width * height;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: stackHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showControls = !showControls;
                    });
                  },
                  child: GifImage(
                    fit: BoxFit.cover,
                    controller: controller,
                    image: NetworkImage(
                      widget.imageUrl,
                      scale: gif.imageInfo.first.imageInfo.scale,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: showControls ? 1.0 : 0,
                  duration: kThemeAnimationDuration,
                  child: Container(
                    color: Colors.grey.withAlpha(80),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Container(),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(getIcon(controller.isAnimating)),
                              onPressed: () {
                                setState(
                                  () {
                                    if (controller.isAnimating) {
                                      controller.stop(canceled: false);
                                      setState(() {
                                        showControls = true;
                                      });
                                    } else {
                                      controller.forward(
                                        from: controller.value,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                            Expanded(
                              child: AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
                                  double value = controller.value;
                                  const double min = 0;
                                  final max = extent.toDouble();
                                  assert(value >= min && value <= max);
                                  return Slider(
                                    value: value,
                                    min: min,
                                    max: max,
                                    onChanged: (double value) {
                                      value =
                                          value.clamp(0, extent - 1).toDouble();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getIcon(bool isPlaying) {
    if (isPlaying) {
      return Icons.pause;
    } else {
      return Icons.play_arrow;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
