import 'package:built_value/built_value.dart';

part 'authentication.state.g.dart';

abstract class AuthenticationState
    implements Built<AuthenticationState, AuthenticationStateBuilder> {
  // Fields
  bool get isLoading;
  bool get isSignedIn;

  @nullable
  String get token;

  @nullable
  String get username;

  AuthenticationState._();

  factory AuthenticationState(
          [void Function(AuthenticationStateBuilder) updates]) =
      _$AuthenticationState;
}
