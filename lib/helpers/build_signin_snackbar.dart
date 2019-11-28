import 'package:flutter/material.dart';
import 'package:flutter_provider_app/exports.dart';

void buildSnackBar(BuildContext context) {
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text('Please sign-in to vote'),
    action: SnackBarAction(
      onPressed: () {
        Provider.of<UserInformationProvider>(context).performAuthentication();
        launchURL(
            context,
            "https://www.reddit.com/api/v1/authorize.compact?client_id=" +
                CLIENT_ID +
                "&response_type=code&state=randichid&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread");
      },
      label: "Sign In",
    ),
  ));
}
