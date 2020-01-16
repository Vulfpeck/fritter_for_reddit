import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/pages/search_screen.dart';
import 'package:flutter_provider_app/pages/user_profile.dart';
import 'package:flutter_provider_app/widgets/feed/subreddit_feed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  CupertinoTabController _tabController = CupertinoTabController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await currentNavigatorKey().currentState.maybePop();
      },
      child: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).cardColor.withOpacity(0.7),
          activeColor: Theme.of(context).accentColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
              ),
              title: Text("Feed"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              title: Text("Account"),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              {
                return CupertinoTabView(
                  navigatorKey: firstTabNavKey,
                  builder: (BuildContext context) => SubredditFeed(),
                );
              }
            case 1:
              {
                return CupertinoTabView(
                  navigatorKey: secondTabNavKey,
                  builder: (BuildContext context) => SearchPage(),
                );
              }
            case 2:
              {
                return CupertinoTabView(
                  navigatorKey: thirdTabNavKey,
                  builder: (BuildContext context) => UserProfileScreen(),
                );
              }
            default:
              {
                return Container();
              }
          }
        },
      ),
    );
  }

  GlobalKey<NavigatorState> currentNavigatorKey() {
    switch (_tabController.index) {
      case 0:
        return firstTabNavKey;
        break;
      case 1:
        return secondTabNavKey;
        break;
      case 2:
        return thirdTabNavKey;
        break;
    }

    return null;
  }
}
