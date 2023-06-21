import 'package:redux/redux.dart';

int counterReducer(int state, dynamic action) {
  return state;
}

final reduxStore = Store(counterReducer, initialState: 0);
