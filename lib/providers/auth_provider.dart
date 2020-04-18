import 'package:flutter/cupertino.dart';
import 'package:fritter_for_reddit/providers/state_persisting_change_notifier.dart';
import 'package:draw/draw.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> login(
      {@required String username, @required String password}) async {
    return;
  }
}

class AuthState extends SerializableClass<AuthState> {
  final bool isAuthenticated;

  AuthState({@required this.isAuthenticated});

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  AuthState fromJson() {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
