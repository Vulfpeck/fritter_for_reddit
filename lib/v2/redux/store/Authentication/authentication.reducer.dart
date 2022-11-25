import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.action.dart';
import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.state.dart';

final authenticationReducer = (AuthenticationState state, action) {
  if (action is SetAuthenticationLoadingAction) {
    return state.rebuild((p0) => p0..isLoading = action.isLoading);
  }
  if (action is SetSignedInUserAction) {
    return state.rebuild(
      (p0) => p0
        ..token = action.token
        ..username = action.username
        ..isSignedIn = action.isSignedIn,
    );
  }
  if (action is SignInUserAction) {
    print(action);
    return state;
  }
  return state;
};
