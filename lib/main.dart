import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'exports.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color.fromARGB(0, 255, 255, 255),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(ChangeNotifierProvider(
    builder: (_) => UserInformationProvider(),
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
      body: Provider.of<UserInformationProvider>(context).state ==
              ViewState.Busy
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Provider.of<UserInformationProvider>(context).signedIn
                      ? Text('Signed in')
                      : Text('Sign in on the left'),
                ),
                RaisedButton(
                    child: Text('Refresh access token'),
                    onPressed:
                        Provider.of<UserInformationProvider>(context).signedIn
                            ? () {
                                Provider.of<UserInformationProvider>(context)
                                    .performTokenRefresh();
                              }
                            : null),
                RaisedButton(
                  child: Text('Sign out'),
                  onPressed:
                      Provider.of<UserInformationProvider>(context).signedIn
                          ? () {
                              Provider.of<UserInformationProvider>(context)
                                  .signOutUser();
                            }
                          : null,
                )
              ],
            ),
      drawer: Drawer(
        child: Consumer<UserInformationProvider>(
            builder: (BuildContext context, UserInformationProvider model, _) {
          if (model.signedIn) {
            if (model.state == ViewState.Busy) {
              return Center(child: CircularProgressIndicator());
            } else if (model.state == ViewState.Idle) {
              return ListView.builder(
                itemBuilder: (context, int index) {
                  return ListTile(
                    title: Text(model
                        .userInformation.subredditsList[index].displayName),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(model
                          .userInformation.subredditsList[index].communityIcon),
                    ),
                  );
                },
                itemCount: model.userInformation.subredditsList.length,
              );
            }
          } else {
            return SafeArea(
              child: ListTile(
                title: Text("Sign into reddit"),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).accentColor,
                  child: Icon(
                    Icons.person_outline,
                  ),
                ),
                onTap: () {
                  model.performAuthentication();
                },
              ),
            );
          }
          return Container();
        }),
      ),
    );
  }
}
