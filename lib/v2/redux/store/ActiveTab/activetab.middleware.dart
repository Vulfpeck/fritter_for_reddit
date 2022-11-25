import 'package:fritter_for_reddit/v2/redux/store/App/app.state.dart';
import 'package:redux/redux.dart';

Middleware<AppState> getActiveTab() {
  return (Store<AppState> store, action, NextDispatcher dispatch) async {
    dispatch(action);
    try {
      // TODO: Write here your middleware logic and api calls
    } catch (error) {
      // TODO: API Error handling
      print(error);
    }
  };
}
