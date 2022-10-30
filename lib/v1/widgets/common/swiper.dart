import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:fritter_for_reddit/v1/helpers/design_system/color_enums.dart';
import 'package:fritter_for_reddit/v1/helpers/design_system/colors.dart';
import 'package:fritter_for_reddit/v1/models/comment_chain/comment.dart'
    as CommentPojo;

import '../../exports.dart';

class Swiper extends StatefulWidget {
  final Widget child;
  final String postId;
  final CommentPojo.Child comment;
  final int commentIndex;

  Swiper(
      {@required this.child,
      @required this.comment,
      @required this.postId,
      @required this.commentIndex});

  @override
  _SwiperState createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isUpvoting = false;
  bool thresholdCrossed = false;
  DismissDirection direction;
  Offset commentOffset = Offset.zero;
  MediaQueryData _mediaQuery;
  bool isDragging = false;
  double initialPosition = 0;
  double finalPosition = 0;
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
        initialPosition = details.localPosition.dx;
        thresholdCrossed = false;
        isUpvoting = false;
      },
      onHorizontalDragUpdate: (details) {
        finalPosition = details.localPosition.dx;
        setState(
          () {
            commentOffset += Offset(details.delta.dx, 0);
            final double change = (finalPosition - initialPosition);
            final double ratio =
                change < 0 ? change * -1 / size.width : change / size.width;
            // print("Drag ratio : " + ratio.toString());
            if (change < 0) {
              if (ratio >= 0 && ratio < 0.15) {
                isUpvoting = false;
                thresholdCrossed = false;
              }
              if (ratio >= 0.15 && ratio <= 0.4) {
                isUpvoting = true;
                thresholdCrossed = true;
              }
              if (ratio > 0.4 && ratio < 1.0) {
                isUpvoting = false;
                thresholdCrossed = true;
              }
            } else {
              // print("is opp dir");
              isUpvoting = false;
              thresholdCrossed = false;
            }
          },
        );
      },
      onHorizontalDragEnd: (details) {
        final double change = (finalPosition - initialPosition);
        // print(change);
        _runAnimation(details.velocity.pixelsPerSecond, size);
        if (isUpvoting && thresholdCrossed) {
          if (Provider.of<UserInformationProvider>(context).signedIn) {
            if (widget.comment.data.likes == true) {
              Provider.of<CommentsProvider>(context).voteComment(
                index: widget.commentIndex,
                dir: 0,
                postId: widget.postId,
              );
            } else {
              Provider.of<CommentsProvider>(context).voteComment(
                index: widget.commentIndex,
                dir: 1,
                postId: widget.postId,
              );
            }
          } else {
            buildSnackBar(context);
          }
        } else if (!isUpvoting && thresholdCrossed) {
          // print("Downvote");
          if (Provider.of<UserInformationProvider>(context).signedIn) {
            if (widget.comment.data.likes == false) {
              Provider.of<CommentsProvider>(context).voteComment(
                  index: widget.commentIndex, dir: 0, postId: widget.postId);
            } else {
              Provider.of<CommentsProvider>(context).voteComment(
                  index: widget.commentIndex, dir: -1, postId: widget.postId);
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
            right: 0,
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              alignment: Alignment.centerRight,
              color: thresholdCrossed
                  ? isUpvoting
                      ? getColor(_mediaQuery.platformBrightness,
                          ColorObjects.UpvoteColor)
                      : getColor(
                          _mediaQuery.platformBrightness,
                          ColorObjects.DownvoteColor,
                        )
                  : Theme.of(context).dividerColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: thresholdCrossed
                    ? isUpvoting
                        ? Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          )
                    : Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "🐶boop",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6,
              ),
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
