import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fritter_for_reddit/v1/exports.dart';
import 'package:fritter_for_reddit/v2/api/authentication.dart';
import 'package:http/http.dart' as http;

HttpServer server;

Future startLocalServerAndGetAuthToken(
  Function(String accessToken, String refreshToken) onAuthComplete,
  Function onAuthFailed,
) async {
  if (server != null) {
    await server.close(force: true);
  }
  debugPrint('**starting auth server**');
  // start a new instance of the server that listens to localhost requests
  Stream<String> onCode = await accessCodeServer();

  // server returns the first access_code it receives
  final String accessCode = await onCode.first;

  if (accessCode == null) {
    onAuthFailed();
    return;
  }

  // now we use this code to obtain authentication token and other data
  try {
    final tokens = await getTokensFromAccessCode(accessCode);
    onAuthComplete(tokens.authToken, tokens.refreshToken);
  } catch (e) {
    debugPrint(e);
    debugPrintStack();
    onAuthFailed();
  }
}

Future<Stream<String>> accessCodeServer() async {
  final StreamController<String> onCode = new StreamController();
  server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.listen(
    (HttpRequest request) async {
      final String code = request.uri.queryParameters["code"];
      request.response
        ..statusCode = 200
        ..headers.set("Content-Type", ContentType.html.mimeType)
        ..write(
            '<html><meta name="viewport" content="width=device-width, initial-scale=1.0"><body> <h2 style="text-align: center; position: absolute; top: 50%; left: 0: right: 0">Welcome to Fritter</h2><h3>You can close this window<script type="javascript">window.close()</script> </h3></body></html>');
      await request.response.close();
      await server.close(force: true);
      onCode.add(code);
      await onCode.close();
    },
  );

  return onCode.stream;
}
