import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/exports.dart';

void buildSnackBar(BuildContext context) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Please sign-in to vote'),
    action: SnackBarAction(
      onPressed: () {
        Provider.of<UserInformationProvider>(context).performAuthentication();
        launchURL(
            Theme.of(context).primaryColor,
            "https://www.reddit.com/api/v1/authorize.compact?client_id=" +
                CLIENT_ID +
                "&response_type=code&state=samplestate&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread");
      },
      label: "Sign In",
    ),
  ));
}
