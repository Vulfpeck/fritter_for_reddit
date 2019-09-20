import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_provider_app/auth/auth_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(0, 255, 255, 255),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(ChangeNotifierProvider(
    builder: (_) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String code;
  String authToken;
  String refreshToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tushyboi\'s reddit app'),
      ),
      body: Provider.of<AuthProvider>(context).isLoading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Provider.of<AuthProvider>(context).signedIn
                      ? Text('Signed in')
                      : Text('Sign in on the left'),
                ),
              ],
            ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Provider.of<AuthProvider>(context).signedIn
                ? ListTile(
                    title: Text('Sign out of reddit'),
                    leading: Icon(Icons.zoom_out_map),
                    onTap: () {
                      Provider.of<AuthProvider>(context).signOutUser();
                    },
                  )
                : ListTile(
                    title: Text('Sign into reddit'),
                    leading: Icon(Icons.airline_seat_flat),
                    onTap: () {
                      Provider.of<AuthProvider>(context).authenticateUser();
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getPostsExample() async {
    http.Response res = await http.get(
      'http://oauth.reddit.com/api/v1/me/prefs',
      headers: {
        'Authorization': 'bearer ' + authToken,
        'User-Agent': 'fritter_reddit by sexusmexus'
      },
    );

    print(json.decode(res.body));
  }
}
