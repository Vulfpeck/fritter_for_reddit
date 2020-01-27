import 'package:flutter/material.dart';

class BlurredSliverAppBar extends StatelessWidget {
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      floating: true,
      pinned: true,
      delegate: _BlurredSliverAppBarDelegate(
        safeAreaPadding: MediaQuery.of(context).padding,
        title: title,
      ),
    );
  }

  BlurredSliverAppBar({this.title});
}

class _BlurredSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  /// This is required to calculate the height of the bar
  ///
  final EdgeInsets safeAreaPadding;

  final String title;
  _BlurredSliverAppBarDelegate({this.safeAreaPadding, this.title});

  @override
  double get minExtent => safeAreaPadding.top;

  @override
  double get maxExtent => minExtent + kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // Don't wrap this in any SafeArea widgets, use padding instead
      padding: EdgeInsets.only(top: safeAreaPadding.top),
      height: maxExtent,
      color: Theme.of(context).cardColor.withOpacity(0.8),
      // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBar(
              primary: false,
              brightness: MediaQuery.of(context).platformBrightness,
              automaticallyImplyLeading: true,
              elevation: 0,
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Colors.transparent,
              title: Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_BlurredSliverAppBarDelegate old) {
    return maxExtent != old.maxExtent ||
        minExtent != old.minExtent ||
        safeAreaPadding != old.safeAreaPadding;
  }
}
