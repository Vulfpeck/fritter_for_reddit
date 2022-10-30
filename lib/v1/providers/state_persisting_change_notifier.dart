import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:hive/hive.dart';

/// Every time notifyListeners is called, the state is persisted to allow easy app persistence.
/// Persistence is based on Hive with a box opened with the class name.
/// If this is not desired, supply an alternative [boxName] in the constructor.
///
/// Listeners are automatically notified whenever [state] changes.
abstract class StatePersistingChangeNotifier<T extends SerializableClass>
    extends ChangeNotifier {
  final Completer<bool> isInitializedCompleter = Completer();

  Future<bool> get initializationFuture => isInitializedCompleter.future;

  Box _storage;
  T _state;

  T get state => _state;

  set state(T state) {
    _state = state;
    writeState(state);
    notifyListeners();
  }

  StatePersistingChangeNotifier({String boxName}) {
    _state = initialState;
    Hive.openBox(boxName ?? runtimeType.toString()).then((box) {
      _storage = box;
      isInitializedCompleter.complete(true);
      state = fromJson(_storage.get('state')) ?? initialState;
      notifyListeners();
    });
  }

  T fromJson(Map json);

  @mustCallSuper
  void writeState(T state) async {
    await initializationFuture;
    debugPrint('Writing state: $state');
    _storage.put('state', state.toJson());
  }

  T get initialState;
}

abstract class SerializableClass<T> {
  Map<String, dynamic> toJson();
}
