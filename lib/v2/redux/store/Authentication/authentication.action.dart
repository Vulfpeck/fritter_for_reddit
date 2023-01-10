abstract class AuthenticationAction {}

class SetAuthenticationLoadingAction implements AuthenticationAction {
  final bool isLoading;

  SetAuthenticationLoadingAction(this.isLoading);
}

class SetSignedInUserAction implements AuthenticationAction {
  final String? token, username;
  final bool isSignedIn;

  SetSignedInUserAction(this.token, this.username, this.isSignedIn);
}

class SignInUserAction implements AuthenticationAction {}

class SignOutUserAction implements AuthenticationAction {}
