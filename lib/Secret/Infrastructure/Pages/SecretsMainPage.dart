import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Secret/Application/SecretsManager.dart';
import '../../Domain/Secret.dart';
import '../Widgets/SecretEditableCard.dart';
import 'SecretConfirmationPage.dart';

_SecretsMainPageState mainPageState = _SecretsMainPageState();

class SecretsMainPage extends StatefulWidget {

  SecretsMainPage({Key? key, required this.title, required List<Secret> secrets}) {

    secretWrappers = [];

    for(Secret secret in secrets) {
      secretWrappers.add(SecretWrapper(secret: secret));
    }

  }

  final String title;
  List<SecretWrapper> secretWrappers = [];

  @override
  State<SecretsMainPage> createState() => mainPageState;
}

class _SecretsMainPageState extends State<SecretsMainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: widget.secretWrappers.length,
            itemBuilder: (BuildContext context, int i) {
              SecretWrapper secretWrapper = widget.secretWrappers[i];
              secretWrapper.secret.uris = secretWrapper.secret.uris;
              return SecretEditableCard(key: UniqueKey(), secretWrapper: secretWrapper, refreshParent: refresh,);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {createSecretButtonOnPressed();},
          tooltip: 'Create secret',
          child: const Icon(Icons.add),
        ),
      );
  }

  void createSecretButtonOnPressed() {
    Secret newSecret = SecretsManager.create();

    setState(() {
      widget.secretWrappers.add(SecretWrapper(secret: newSecret, isBeingEdited: true));
    });
  }

  void refresh() {
    setState(() {});
  }

}

class SecretWrapper {

  Secret secret;
  bool isBeingEdited;

  SecretWrapper({required this.secret, this.isBeingEdited = false});

}