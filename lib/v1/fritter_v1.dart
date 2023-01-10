import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/models/subreddit_info/subreddit_information_entity.dart';
import 'package:fritter_for_reddit/v1/pages/app_home.dart';
import 'package:fritter_for_reddit/v1/providers/feed_provider.dart';
import 'package:fritter_for_reddit/v1/providers/settings_change_notifier.dart';
import 'package:fritter_for_reddit/v1/widgets/common/go_to_subreddit.dart';
import 'package:fritter_for_reddit/v1/widgets/common/platform_builder.dart';
import 'package:fritter_for_reddit/v1/widgets/desktop/desktop_subreddit_feed.dart';
import 'package:fritter_for_reddit/v1/widgets/desktop/subreddit_side_panel.dart';
import 'package:fritter_for_reddit/v1/widgets/drawer/drawer.dart';

class Fritter extends StatefulWidget {
  @override
  _FritterState createState() => _FritterState();
}

class _FritterState extends State<Fritter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      debugShowMaterialGrid: false,
      home: PlatformBuilder(
        macOS: (context) {
          return DesktopHome();
        },
        fallback: (context) => HomePage(),
      ),
    );
  }
}

class DesktopHome extends StatefulWidget {
  const DesktopHome({
    Key? key,
  }) : super(key: key);

  @override
  _DesktopHomeState createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey key = new GlobalKey();
  FeedProvider get feedProvider => FeedProvider.of(context);
  String sortSelectorValue = "Best";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SubredditInfo>(
      stream: FeedProvider.of(context).subStream,
      builder: (context, snapshot) {
        final SubredditInfo? subredditInfo = snapshot.data;
        final SubredditInformationEntity? subredditInformationData =
            subredditInfo?.subredditInformation;
        if (!snapshot.hasData) {
          return Center(child: CupertinoActivityIndicator());
        }
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Fritter for Reddit"),
            elevation: 0,
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
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
              )
            ],
          ),
          body: Row(
            children: <Widget>[
              Container(
                child: LeftDrawer(
                  mode: Mode.desktop,
                ),
                constraints: BoxConstraints.tightForFinite(width: 250),
              ),
            ],
          ),
          endDrawer: SubredditSidePanel(
            subredditInformation: subredditInformationData,
          ),
        );
      },
    );
  }
}
