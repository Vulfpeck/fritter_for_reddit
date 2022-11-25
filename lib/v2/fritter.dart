import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fritter_for_reddit/v2/redux/store/App/app.state.dart';
import 'package:fritter_for_reddit/v2/screens/mobile/ProfilePage/profile.dart';
import 'package:fritter_for_reddit/v2/screens/mobile/search.dart';
import 'package:fritter_for_reddit/v2/shared/bottom_navigation_tab.dart';
import 'package:redux/redux.dart';

class Fritter extends StatelessWidget {
  final Store<AppState> store;

  Fritter(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: ThemeMode.system,
        showPerformanceOverlay: true,
        home: Scaffold(
          appBar: AppBar(
            title: Text('Fritter!'),
          ),
          bottomNavigationBar: AppBottomNavigationBar(),
          body: StoreConnector<AppState, int>(
            converter: (store) => store.state.activeTabState.activeTab,
            builder: (context, vm) => AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: <Widget>[ProfilePage(), SearchPage()][vm],
            ),
          ),
        ),
      ),
    );
  }
}
