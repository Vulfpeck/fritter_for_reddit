import 'package:flutter/cupertino.dart';
import 'package:fritter_for_reddit/providers/state_persisting_change_notifier.dart';
import 'package:fritter_for_reddit/widgets/desktop/desktop_subreddit_feed.dart';

class SettingsNotifier extends StatePersistingChangeNotifier<SettingsState> {
  @override
  SettingsState get initialState => SettingsState.initial();

  void changeViewMode(ViewMode viewMode) =>
      state = state.copyWith(viewMode: viewMode);

  @override
  SettingsState fromJson(Map<dynamic, dynamic> json) {
    return SettingsState.fromJson(json);
  }
}

@immutable
class SettingsState extends SerializableClass {
  final ViewMode viewMode;

  SettingsState({@required this.viewMode});

  @override
  String toString() {
    return 'SettingsState{viewMode: $viewMode}';
  }

  SettingsState.initial() : viewMode = ViewMode.card;

  @override
  factory SettingsState.fromJson(Map json) {
    if (json == null) {
      return SettingsState.initial();
    }
    return SettingsState(
      viewMode: viewModeFromString(json['viewMode']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {'viewMode': viewMode.toString()};

  static ViewMode viewModeFromString(String viewModeString) {
    switch (viewModeString) {
      case 'ViewMode.card':
        return ViewMode.card;
      case 'ViewMode.gallery':
        return ViewMode.gallery;
      default:
        {
          debugPrint(
              '$viewModeString is not a supported ViewMode setting. Returning ViewMode.card');
          return ViewMode.card;
        }
    }
  }

  SettingsState copyWith({
    ViewMode viewMode,
  }) =>
      SettingsState(
        viewMode: viewMode ?? this.viewMode,
      );
}
