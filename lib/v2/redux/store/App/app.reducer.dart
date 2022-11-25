import 'package:fritter_for_reddit/v2/redux/store/ActiveTab/activetab.reducer.dart';
import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.reducer.dart';
import 'package:redux/redux.dart';
import './app.state.dart';

AppState appReducer(AppState state, action) => new AppState(
      authenticationReducer(state.authenticationState, action),
      activeTabReducer(state.activeTabState, action),
    );
