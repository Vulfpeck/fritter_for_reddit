import 'package:fritter_for_reddit/v2/redux/store/ActiveTab/activetab.action.dart';
import 'package:fritter_for_reddit/v2/redux/store/ActiveTab/activetab.state.dart';

final activeTabReducer = (ActiveTabState state, action) {
  if (action is UpdateActiveTab) {
    return state.rebuild((p0) => p0..activeTab = action.newTabIndex);
  }
  return state;
};
