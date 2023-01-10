// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activetab.state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ActiveTabState extends ActiveTabState {
  @override
  final int activeTab;

  factory _$ActiveTabState([void Function(ActiveTabStateBuilder)? updates]) =>
      (new ActiveTabStateBuilder()..update(updates))._build();

  _$ActiveTabState._({required this.activeTab}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        activeTab, r'ActiveTabState', 'activeTab');
  }

  @override
  ActiveTabState rebuild(void Function(ActiveTabStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ActiveTabStateBuilder toBuilder() =>
      new ActiveTabStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ActiveTabState && activeTab == other.activeTab;
  }

  @override
  int get hashCode {
    return $jf($jc(0, activeTab.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ActiveTabState')
          ..add('activeTab', activeTab))
        .toString();
  }
}

class ActiveTabStateBuilder
    implements Builder<ActiveTabState, ActiveTabStateBuilder> {
  _$ActiveTabState? _$v;

  int? _activeTab;
  int? get activeTab => _$this._activeTab;
  set activeTab(int? activeTab) => _$this._activeTab = activeTab;

  ActiveTabStateBuilder();

  ActiveTabStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _activeTab = $v.activeTab;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ActiveTabState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ActiveTabState;
  }

  @override
  void update(void Function(ActiveTabStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ActiveTabState build() => _build();

  _$ActiveTabState _build() {
    final _$result = _$v ??
        new _$ActiveTabState._(
            activeTab: BuiltValueNullFieldError.checkNotNull(
                activeTab, r'ActiveTabState', 'activeTab'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
