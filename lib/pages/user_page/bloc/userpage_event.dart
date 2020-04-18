part of 'userpage_bloc.dart';

@immutable
abstract class UserPageEvent {}

class YieldUserPageState extends UserPageEvent {
  final UserPageState state;

  YieldUserPageState(this.state);
}
