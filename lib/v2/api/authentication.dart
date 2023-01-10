import 'dart:convert';
import 'dart:io';

import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v1/utils/extensions.dart';

import 'package:http/http.dart' as http;

final authenticationStartUrl = Uri.parse(
  "https://www.reddit.com/api/v1/${PlatformX.isDesktop ? 'authorize' : 'authorize.compact'}?client_id=" +
      CLIENT_ID +
      "&response_type=code&state=samplestate&redirect_uri=http://localhost:8080/&duration=permanent&scope=identity,edit,flair,history,modconfig,modflair,modlog,modposts,modwiki,mysubreddits,privatemessages,read,report,save,submit,subscribe,vote,wikiedit,wikiread",
);

class GetAuthTokenResponse {
  final String? authToken, refreshToken;

  GetAuthTokenResponse(this.authToken, this.refreshToken);
}

Future<GetAuthTokenResponse> getTokensFromAccessCode(String accessCode) async {
  String user = CLIENT_ID;
  String password = ""; // blank for unknown clients like apps

  String basicAuth = "Basic " + base64Encode(utf8.encode('$user:$password'));
  final response = await http.post(
    Uri.parse("https://www.reddit.com/api/v1/access_token"),
    headers: {
      "Authorization": basicAuth,
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body:
        "grant_type=authorization_code&code=$accessCode&redirect_uri=http://localhost:8080/",
  );

  if (response.statusCode != 200) {
    throw new Exception('Invalid response from reddit api');
  }

  Map<String, dynamic> map = json.decode(response.body);
  final String? accessToken = map['access_token'];
  final String? refreshToken = map['refresh_token'];

  return new GetAuthTokenResponse(accessToken, refreshToken);
}
