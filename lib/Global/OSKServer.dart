import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Secret/Infrastructure/API/SecretAPI.dart';
import '../Secret/Infrastructure/Pages/SecretConfirmationPage.dart';
import '../main.dart';

class OSKServer {

  static Future<void> start() async {

    var server = await HttpServer.bind(InternetAddress.anyIPv4, 17867);

    print("Server running on IP : "+server.address.toString()+" On Port : "+server.port.toString());

    await for (var request in server) {

      print("Atending request");

      final pathSegments = request.uri.pathSegments;

      final path = pathSegments.length > 1 ? pathSegments.first : "other";

      switch (path) {
        case 'secret':
          SecretAPI.handle(request);
          break;
        default:
          handleOther(request);
      }
    }
  }

  static void handleOther(HttpRequest request) async {

    request.response
    ..headers.contentType = ContentType("text", "plain", charset: "utf-8")
    ..write('Not found or invalid input')
    ..close();
  }


}