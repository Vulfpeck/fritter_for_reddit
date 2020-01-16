import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_provider_app/helpers/design_system/color_enums.dart';
import 'package:flutter_provider_app/helpers/design_system/colors.dart';
import 'package:flutter_provider_app/models/comment_chain/comment.dart'
    as CommentPojo;

import '../../exports.dart';

class Swiper extends StatefulWidget {
  final Widget child;
  final String postId;
  final CommentPojo.Child comment;

  Swiper({@required this.child, @required this.comment, @required this.postId});

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isUpvoting = true;
  DismissDirection direction;
  Offset commentOffset = Offset.zero;
  MediaQueryData _mediaQuery;

  Animation<Alignment> _animation;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: Alignment(commentOffset.dx / size.width, 0),
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 100,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);
    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        commentOffset =
            Offset(_animation.value.x * MediaQuery.of(context).size.width, 0);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onHorizontalDragDown: (details) {
        _controller.stop();
      },
      onHorizontalDragStart: (details) {
        print(details.localPosition.dx);
        if (details.globalPosition.dx < size.width / 2) {
          direction = DismissDirection.startToEnd;
        } else {
          direction = DismissDirection.endToStart;
        }
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          commentOffset += Offset(details.delta.dx, 0);
          if ((-1 * commentOffset.dx) / size.width > 0.0 &&
              (-1 * commentOffset.dx) / size.width < 0.40) {
            isUpvoting = true;
          } else {
            isUpvoting = false;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
        if (isUpvoting && direction == DismissDirection.endToStart) {
          if (Provider.of<UserInformationProvider>(context).signedIn) {
            if (widget.comment.data.likes == true) {
              Provider.of<CommentsProvider>(context).voteComment(
                id: widget.comment.data.id,
                dir: 0,
                postId: widget.postId,
              );
            } else {
              Provider.of<CommentsProvider>(context).voteComment(
                id: widget.comment.data.id,
                dir: 1,
                postId: widget.postId,
              );
            }
          } else {
            buildSnackBar(context);
          }
        } else if (!isUpvoting && direction == DismissDirection.endToStart) {
          print("Downvote");
          if (Provider.of<UserInformationProvider>(context).signedIn) {
            if (widget.comment.data.likes == false) {
              Provider.of<CommentsProvider>(context).voteComment(
                  id: widget.comment.data.id, dir: 0, postId: widget.postId);
            } else {
              Provider.of<CommentsProvider>(context).voteComment(
                  id: widget.comment.data.id, dir: -1, postId: widget.postId);
            }
          } else {
            buildSnackBar(context);
          }
        }
      },
      onHorizontalDragCancel: () {},
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 150),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: direction == DismissDirection.startToEnd
                    ? Text(
                        "🐶 B O O P",
                        style: Theme.of(context).textTheme.title,
                      )
                    : isUpvoting
                        ? Icon(
                            Icons.arrow_upward,
                            color: getColor(_mediaQuery.platformBrightness,
                                ColorObjects.UpvoteColor),
                          )
                        : Icon(
                            Icons.arrow_downward,
                            color: getColor(
                              _mediaQuery.platformBrightness,
                              ColorObjects.DownvoteColor,
                            ),
                          ),
              ),
              alignment: direction == DismissDirection.startToEnd
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
            ),
          ),
          Transform.translate(
            offset: commentOffset,
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
