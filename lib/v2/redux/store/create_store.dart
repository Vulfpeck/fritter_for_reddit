import 'package:fritter_for_reddit/v2/redux/store/App/app.reducer.dart';
import 'package:fritter_for_reddit/v2/redux/store/App/app.state.dart';
import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.middleware.dart';
import 'package:fritter_for_reddit/v2/repository/user.dart';
import 'package:redux/redux.dart';

Future<Store<AppState>> createStore() async {
  final UserRepository userRepository = await UserRepository.create();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(userRepository),
    middleware: [
      getAuthenticationMiddleware(userRepository),
    ],
  );

  return store;
}
