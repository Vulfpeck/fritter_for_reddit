import 'package:fritter_for_reddit/v2/redux/store/ActiveTab/activetab.state.dart';
import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.state.dart';
import 'package:fritter_for_reddit/v2/repository/user.dart';

class AppState {
  AuthenticationState authenticationState;
  ActiveTabState activeTabState;

  AppState(this.authenticationState, this.activeTabState);

  factory AppState.initial(
    UserRepository userRepository,
  ) =>
      AppState(
        new AuthenticationState(
          (value) => value
            ..isLoading = false
            ..isSignedIn = userRepository.tokenData.authToken != null
            ..token = userRepository.tokenData.authToken,
        ),
        ActiveTabState(
          (value) => value..activeTab = 0,
        ),
      );
}
