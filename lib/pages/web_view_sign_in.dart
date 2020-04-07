import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';
import 'package:fritter_for_reddit/secrets.dart';
import 'package:fritter_for_reddit/utils/extensions.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewSignIn extends StatefulWidget {
  @override
  _WebViewSignInState createState() => _WebViewSignInState();
}

class _WebViewSignInState extends State<WebViewSignIn> {
  @override
  Widget build(BuildContext context) {
    final String url =
        "https://www.reddit.com/api/v1/${PlatformX.isDesktop ? 'authorize' : 'authorize.compact'}?client_id=" +
            CLIENT_ID +
            "&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread";

    // print(url);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.cancel),
            label: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, UserInformationProvider model, _) {
          return model.authenticationStatus == ViewState.busy
              ? Column(
                  children: <Widget>[
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Text('Hold on tight!'),
                    Text(
                        "We're asking reddit to allow us to let you waste your time"),
                    Text('Authenticating with Reddit'),
                  ],
                )
              : SafeArea(
                  child: WebView(
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    debuggingEnabled: false,
                    userAgent: 'Fritter by /u/sexusmexus',
                  ),
                );
        },
      ),
    );
  }
}
