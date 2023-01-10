import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/providers/settings_change_notifier.dart';
import 'package:fritter_for_reddit/v1/widgets/desktop/desktop_subreddit_feed.dart';

class DesktopSliverAppBar extends StatefulWidget {
  final SubredditInfo subredditInfo;
  final VoidCallback onInfoButtonPressed;

  const DesktopSliverAppBar({
    Key? key,
    required this.subredditInfo,
    required this.onInfoButtonPressed,
  }) : super(key: key);

  @override
  _DesktopSliverAppBarState createState() => _DesktopSliverAppBarState();
}

class _DesktopSliverAppBarState extends State<DesktopSliverAppBar> {
  final GlobalKey key = new GlobalKey();

  FeedProvider get feedProvider => FeedProvider.of(context);

  SubredditInfo get subredditInfo => widget.subredditInfo;

  String sortSelectorValue = "Best";

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: Theme.of(context).iconTheme,
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            subredditInfo.name!.isNotEmpty ? subredditInfo.name! : 'FrontPage',
            textAlign: TextAlign.center,
          ),
          Text(
            '/r/${subredditInfo.name!.isNotEmpty ? subredditInfo.name : 'FrontPage'}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          key: key,
          icon: Icon(
            Icons.sort,
          ),
          onSelected: (value) {
            final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
            final positionDropDown = box.localToGlobal(Offset.zero);
            // print(
            if (value == "Top") {
              sortSelectorValue = "Top";
              showMenu(
                position: RelativeRect.fromLTRB(
                  positionDropDown.dx,
                  positionDropDown.dy,
                  0,
                  0,
                ),
                context: context,
                items: <String>[
                  'Day',
                  'Week',
                  'Month',
                  'Year',
                  'All',
                ].map((value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: ListTile(
                      title: Text(value),
                      onTap: () {
                        Navigator.of(context, rootNavigator: false).pop();

                        feedProvider.updateSorting(
                          sortBy: "/top/.json?sort=top&t=$value",
                          loadingTop: true,
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            } else if (value == 'Close' || value == sortSelectorValue) {
            } else {
              sortSelectorValue = value;
              feedProvider.updateSorting(
                sortBy: value,
                loadingTop: false,
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return <String>[
              'Best',
              'Hot',
              'Top',
              'New',
              'Controversial',
              'Rising'
            ].map((String value) {
              return new PopupMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList();
          },
          onCanceled: () {},
          initialValue: sortSelectorValue,
        ),
        IconButton(
          icon: Icon(Icons.info_outline),
          color: Theme.of(context).iconTheme.color,
          onPressed: widget.onInfoButtonPressed,
        )
      ],
      pinned: true,
      snap: true,
      floating: true,
      primary: true,
      elevation: 0,
      brightness: MediaQuery.of(context).platformBrightness,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      textTheme: Theme.of(context).textTheme,
    );
  }
}
