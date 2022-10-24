import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/models/postsfeed/posts_feed_entity.dart';
import 'package:fritter_for_reddit/models/subreddit_info/subreddit_information_entity.dart';
import 'package:fritter_for_reddit/pages/app_home.dart';
import 'package:fritter_for_reddit/providers/search_provider.dart';
import 'package:fritter_for_reddit/providers/settings_change_notifier.dart';
import 'package:fritter_for_reddit/widgets/common/go_to_subreddit.dart';
import 'package:fritter_for_reddit/widgets/common/platform_builder.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_subreddit_feed.dart';
import 'package:fritter_for_reddit/widgets/desktop/subreddit_side_panel.dart';
import 'package:fritter_for_reddit/widgets/drawer/drawer.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory path = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(SubredditInfoAdapter());
  Hive.registerAdapter(PostsFeedEntityAdapter());
  Hive.registerAdapter(PostsFeedDataAdapter());
  Hive.registerAdapter(PostsFeedDataChildAdapter());
  Hive.init(path.path);
  await Hive.openBox<SubredditInfo>('feed');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserInformationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FeedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => SettingsNotifier(),
        )
      ],
      child: Fritter(),
    ),
  );
}

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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.7),
        ),
        primaryColor: Colors.blue,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.blueGrey.shade50,
              surface: Colors.blueGrey.shade100,
              onSurface: Colors.blueGrey,
              secondary: Colors.blueGrey.shade100,
            ),
        dividerTheme: DividerThemeData(color: Colors.black.withOpacity(0.15)),
        cardColor: Colors.white,
        textTheme: Theme.of(context).textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 15,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade900,
              ),
              bodyText1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade800,
              ),
              caption: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade900,
              ),
              subtitle2: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade700,
              ),
            ),
      ),
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1e1e1e),
        cardColor: Color(0xff1e1e1e),
//        cardColor: Colors.black,
        dividerTheme: DividerThemeData(
          color: Colors.white.withOpacity(0.1),
          thickness: 1,
        ),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        dialogBackgroundColor: Color(0xff313031),
        accentColor: Colors.redAccent,
        colorScheme: Theme.of(context).colorScheme.copyWith(
              background: Colors.black,
              surface: Colors.lightBlue.shade900,
              onSurface: Colors.lightBlue.shade100,
              secondary: Colors.lightBlue.shade800,
            ),
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: Colors.white.withOpacity(0.95),
              ),
              bodyText1: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
              caption: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
              subtitle2: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(
                  0.55,
                ),
              ),
            ),
        primaryIconTheme: IconThemeData(color: Colors.grey),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.grey),
        ),
      ),
    );
  }
}

class DesktopHome extends StatefulWidget {
  const DesktopHome({
    Key key,
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
        final SubredditInfo subredditInfo = snapshot.data;
        final SubredditInformationEntity subredditInformationData =
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
              ViewSwitcherIconButton(
                viewMode: Provider.of<SettingsNotifier>(context).state.viewMode,
                onChanged: (viewMode) {
                  Provider.of<SettingsNotifier>(context, listen: false)
                      .changeViewMode(viewMode);
                },
              ),
              PopupMenuButton<String>(
                key: key,
                icon: Icon(
                  Icons.sort,
                ),
                onSelected: (value) {
                  final RenderBox box = key.currentContext.findRenderObject();
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
              IconButton(icon: Icon(Icons.info_outline), onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              },)
            ],
          ),
          body: Row(
            children: <Widget>[
              Container(child: LeftDrawer(mode: Mode.desktop,), constraints: BoxConstraints.tightForFinite(width: 250),),
              Expanded(
                child: Center(child: DesktopSubredditFeed()),
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
