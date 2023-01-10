// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthenticationState extends AuthenticationState {
  @override
  final bool isLoading;
  @override
  final bool isSignedIn;
  @override
  final String? token;
  @override
  final String? username;

  factory _$AuthenticationState(
          [void Function(AuthenticationStateBuilder)? updates]) =>
      (new AuthenticationStateBuilder()..update(updates))._build();

  _$AuthenticationState._(
      {required this.isLoading,
      required this.isSignedIn,
      this.token,
      this.username})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        isLoading, r'AuthenticationState', 'isLoading');
    BuiltValueNullFieldError.checkNotNull(
        isSignedIn, r'AuthenticationState', 'isSignedIn');
  }

  @override
  AuthenticationState rebuild(
          void Function(AuthenticationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthenticationStateBuilder toBuilder() =>
      new AuthenticationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthenticationState &&
        isLoading == other.isLoading &&
        isSignedIn == other.isSignedIn &&
        token == other.token &&
        username == other.username;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, isLoading.hashCode), isSignedIn.hashCode),
            token.hashCode),
        username.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthenticationState')
          ..add('isLoading', isLoading)
          ..add('isSignedIn', isSignedIn)
          ..add('token', token)
          ..add('username', username))
        .toString();
  }
}

class AuthenticationStateBuilder
    implements Builder<AuthenticationState, AuthenticationStateBuilder> {
  _$AuthenticationState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _isSignedIn;
  bool? get isSignedIn => _$this._isSignedIn;
  set isSignedIn(bool? isSignedIn) => _$this._isSignedIn = isSignedIn;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  AuthenticationStateBuilder();

  AuthenticationStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _isSignedIn = $v.isSignedIn;
      _token = $v.token;
      _username = $v.username;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthenticationState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AuthenticationState;
  }

  @override
  void update(void Function(AuthenticationStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthenticationState build() => _build();

  _$AuthenticationState _build() {
    final _$result = _$v ??
        new _$AuthenticationState._(
            isLoading: BuiltValueNullFieldError.checkNotNull(
                isLoading, r'AuthenticationState', 'isLoading'),
            isSignedIn: BuiltValueNullFieldError.checkNotNull(
                isSignedIn, r'AuthenticationState', 'isSignedIn'),
            token: token,
            username: username);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
