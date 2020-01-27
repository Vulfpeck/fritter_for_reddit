import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_app/widgets/drawer/drawer.dart';

import 'search_screen.dart';
import 'user_profile.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final CupertinoTabController _tabController = CupertinoTabController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await currentNavigatorKey().currentState.maybePop();
      },
      child: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          border: Border.fromBorderSide(
            BorderSide(
              color: CupertinoDynamicColor.resolve(
                Theme.of(context).dividerColor,
                context,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          activeColor: Theme.of(context).accentColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
                size: 24,
              ),
              title: Text("Feed"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 24,
              ),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 24,
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
                  builder: (BuildContext context) => LeftDrawer(
                    firstLaunch: true,
                  ),
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
//    return LeftDrawer(
//      firstLaunch: true,
//    );
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
