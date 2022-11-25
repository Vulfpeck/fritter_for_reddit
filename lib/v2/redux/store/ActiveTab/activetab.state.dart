import 'package:built_value/built_value.dart';

part 'activetab.state.g.dart';

abstract class ActiveTabState
    implements Built<ActiveTabState, ActiveTabStateBuilder> {
  int get activeTab;

  ActiveTabState._();

  factory ActiveTabState([void Function(ActiveTabStateBuilder) updates]) =
      _$ActiveTabState;
}
