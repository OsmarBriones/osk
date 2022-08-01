import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/Secret/Application/SecretsManager.dart';

import '../../../Global/OSKServer.dart';
import '../../../Global/OSKGlobals.dart' as globals;
import '../../../main.dart';
import '../../Domain/Secret.dart';
import '../Pages/SecretConfirmationPage.dart';

class SecretAPI {

  static void handle(HttpRequest request) {

    final pathSegments = request.uri.pathSegments;
    final path = pathSegments[1];

    switch (path) {
      case 'getSecret':
        handleGetSecret(request);
        break;
      case 'addSecret':
        handleAddSecret(request);
        break;
      default:
        OSKServer.handleOther(request);
    }
  }

  static void handleGetSecret(HttpRequest request) async {

    String result = "{}";
    final jsonString = await utf8.decoder.bind(request).join();
    try {

      final Map<String, dynamic> parameters = jsonDecode(jsonString);
      final uri = parameters["uri"];

      final userApproves = await Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => SecretConfirmationPage(
          request: request,
          message: globals.gettingSecretMessage(
              connectionInfo: request.connectionInfo!.remoteAddress,
              uriRequested: uri
          ),
        )),
      );

      if(userApproves) {
        result = SecretsManager.getSecret(uri);
      }

      request.response
        ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
        ..write(result)
        ..close();
    } on FormatException catch (e) {
        OSKServer.handleOther(request);
    }

  }

  static void handleAddSecret(HttpRequest request) async {

    String result = "{}";

    final jsonString = await utf8.decoder.bind(request).join();
    try {

      final Map<String, dynamic> parameters = jsonDecode(jsonString);
      final uri = parameters["uri"];

      final userApproves = await Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => SecretConfirmationPage(
          request: request,
          message: globals.addingSecretMessage(
              connectionInfo: request.connectionInfo!.remoteAddress,
              uriRequested: uri
          ),
        )),
      );

      if(userApproves) {
        result = jsonEncode(SecretsManager.create(uri: [uri]));
      }

      request.response
        ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
        ..write(jsonEncode(result))
        ..close();
    } on FormatException catch (e) {
        OSKServer.handleOther(request);
    }

  }
}