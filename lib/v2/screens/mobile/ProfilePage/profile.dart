import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fritter_for_reddit/v2/redux/store/App/app.state.dart';
import 'package:fritter_for_reddit/v2/redux/store/Authentication/authentication.action.dart';

class LoginButtonState {
  final bool isLoading;
  final bool isSignedIn;
  final Function signIn, signOut;
  final String token;

  LoginButtonState({
    @required this.isLoading,
    @required this.isSignedIn,
    @required this.signIn,
    @required this.signOut,
    @required this.token,
  });
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginButtonState>(
      builder: (context, state) => ElevatedButton(
        onPressed: state.isLoading
            ? null
            : state.isSignedIn
                ? () => state.signOut()
                : () => state.signIn(),
        child: Column(children: [
          if (!state.isSignedIn) Text(state.isLoading ? 'Logging In' : 'Login'),
          if (state.isSignedIn)
            Text(state.isLoading ? 'Logging Out' : 'Log Out'),
          Text(state.token != null ? state.token : 'token empty'),
        ]),
      ),
      converter: (store) => new LoginButtonState(
        isLoading: store.state.authenticationState.isLoading,
        isSignedIn: store.state.authenticationState.isSignedIn,
        signIn: () => store.dispatch(SignInUserAction()),
        signOut: () => store.dispatch(SignOutUserAction()),
        token: store.state.authenticationState.token,
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            LoginButton(),
          ],
        ),
      ],
    );
  }
}
