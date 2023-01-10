import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fritter_for_reddit/v2/redux/store/ActiveTab/activetab.action.dart';
import 'package:fritter_for_reddit/v2/redux/store/App/app.state.dart';

class _AppBottonNavigationState {
  final int activeTab;
  final Function(int) updateActiveTab;

  _AppBottonNavigationState(this.activeTab, this.updateActiveTab);
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AppBottonNavigationState>(
      converter: (store) => _AppBottonNavigationState(
        store.state.activeTabState.activeTab,
        (newTabIndex) => store.dispatch(UpdateActiveTab(newTabIndex)),
      ),
      builder: (context, state) => NavigationBar(
        selectedIndex: state.activeTab,
        onDestinationSelected: state.updateActiveTab,
        destinations: [
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
          NavigationDestination(icon: Icon(Icons.search), label: "Search")
        ],
      ),
    );
  }
}
