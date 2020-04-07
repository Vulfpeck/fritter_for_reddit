import 'dart:io';

import 'package:animated_layout/animated_layout.dart';
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
  AnimatedLayoutController animatedLayoutController;

  @override
  void initState() {
    animatedLayoutController = AnimatedLayoutController(
        duration: kThemeAnimationDuration,
        children: <Widget>[
          SizedBox.expand(
            child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              child: Column(children: [
                Text('Subreddit List'),
                for (int i = 0; i < 10; i++)
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return ListTile(
                        leading: Icon(Icons.image),
                        title: constraints.maxWidth > 200
                            ? Text(
                                'Subreddit Title',
//                              overflow: TextOverflow.fade,
                                softWrap: true,
                              )
                            : null,
//                            subtitle: Text(constraints.maxWidth.toString()),
                      );
                    },
                  )
              ]),
            ),
          ),
          SizedBox.expand(
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              child: Text('Posts Feed'),
            ),
          ),
          SizedBox.expand(
            child: Container(
              alignment: Alignment.center,
              color: Colors.green,
              child: Text('Post/Comments'),
            ),
          )
        ],
        initialDivisions: [
          20,
          60,
          20
        ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                fontSize: 16,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
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
//        scaffoldBackgroundColor: Colors.black,
//        cardColor: Colors.black,
        dividerTheme: DividerThemeData(
          color: Colors.white.withOpacity(0.2),
          thickness: 1,
        ),
        brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
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
  AnimatedLayoutController animatedLayoutController;

  @override
  void initState() {
    super.initState();
    animatedLayoutController ??=
        AnimatedLayoutController(duration: kThemeAnimationDuration, children: [
      Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey),
          ),
        ),
        child: LeftDrawer(
          mode: Mode.desktop,
        ),
      ),
      DesktopSubredditFeed(),
      SubredditSidePanel(
        subredditInformation: null,
      ),
    ], initialDivisions: [
      20,
      60,
      20
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: animatedLayoutController,
      child: StreamBuilder<SubredditInfo>(
          stream: FeedProvider.of(context).subStream,
          builder: (context, snapshot) {
            final SubredditInfo subredditInfo = snapshot.data;
            final SubredditInformationEntity subredditInformationData =
                subredditInfo?.subredditInformation;
            if (!snapshot.hasData) {
              return Container();
            }
            animatedLayoutController.updateChildren([
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey),
                  ),
                ),
                child: LeftDrawer(
                  mode: Mode.desktop,
                ),
              ),
              DesktopSubredditFeed(),
              SubredditSidePanel(
                subredditInformation: subredditInformationData,
              ),
            ]);
            return Scaffold(
              body: AnimatedLayout(
                controller: animatedLayoutController,
                direction: Axis.horizontal,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.list),
                onPressed: () {
                  FeedProvider.of(context).getSubredditRules('AskReddit');
                },
              ),
            );
          }),
    );
  }
}
