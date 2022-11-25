import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v2/fritter.dart';
import 'package:fritter_for_reddit/v2/redux/store/create_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await createStore();

  runApp(Fritter(store));
}
