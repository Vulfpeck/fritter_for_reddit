import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/utils/extensions.dart';
import 'package:fritter_for_reddit/v2/api/authentication.dart';
import 'package:fritter_for_reddit/v2/redux/store/App/app.state.dart';
import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.action.dart';
import 'package:fritter_for_reddit/v2/repository/user.dart';
import 'package:fritter_for_reddit/v2/utils/local_authentication_server.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

Middleware<AppState> getAuthenticationMiddleware(
  UserRepository userRepository,
) {
  return (Store<AppState> store, action, NextDispatcher dispatch) async {
    try {
      if (action is SignInUserAction) {
        store.dispatch(SetAuthenticationLoadingAction(true));
        launchUrl(authenticationStartUrl);

        startLocalServerAndGetAuthToken(
          (accessToken, refreshToken) {
            userRepository.updateTokenData(
              SignedInUserTokenData(
                accessToken,
                refreshToken,
                DateTime.now().add(Duration(hours: 1)),
              ),
            );

            store.dispatch(
              SetSignedInUserAction(accessToken, 'todo', true),
            );
            store.dispatch(SetAuthenticationLoadingAction(false));
          },
          () {
            store.dispatch(SetAuthenticationLoadingAction(true));
          },
        );
        return;
      }

      if (action is SignOutUserAction) {
        store.dispatch(SetAuthenticationLoadingAction(true));
        userRepository.clearTokenData();
        store.dispatch(SetSignedInUserAction(null, null, false));
        store.dispatch(SetAuthenticationLoadingAction(false));
      }

      dispatch(action);
      // TODO: Write here your middleware logic and api calls
    } catch (error) {
      // TODO: API Error handling
      print(error);
    }
  };
}
