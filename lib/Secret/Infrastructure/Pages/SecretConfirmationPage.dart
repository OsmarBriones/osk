import 'dart:io';

import 'package:flutter/material.dart';
import '../../../Global/OSKGlobals.dart' as globals;

class SecretConfirmationPage extends StatefulWidget {

  SecretConfirmationPage({required this.request, required this.message});

  @override
  State<StatefulWidget> createState() => _SecretConfirmationPageState();

  HttpRequest request;
  String message;

}

class _SecretConfirmationPageState extends State<SecretConfirmationPage> {

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    HttpRequest request = widget.request;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          FloatingActionButton(
            heroTag: "okButton",
            onPressed: (){Navigator.pop(context, true);},
            child: const Text(globals.okButton),
          ),
          FloatingActionButton(
            heroTag: "noButton",
            onPressed: (){Navigator.pop(context, false);},
            child: const Text(globals.noButton),
          )
        ],
      ),
    );
  }



}