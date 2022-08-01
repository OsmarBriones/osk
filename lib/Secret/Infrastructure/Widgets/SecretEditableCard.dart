import 'package:flutter/material.dart';
import 'package:untitled/Secret/Application/SecretsManager.dart';
import 'package:untitled/Secret/Infrastructure/Pages/SecretsMainPage.dart';
import '../../Domain/Secret.dart';
import '../../../Global/OSKGlobals.dart' as globals;

class SecretEditableCard extends StatefulWidget {
  SecretEditableCard({Key? key, required this.secretWrapper, required this.refreshParent});

  SecretWrapper secretWrapper;
  Function() refreshParent;


  @override
  State<SecretEditableCard> createState() => _SecretEditableCardState();
}

class _SecretEditableCardState extends State<SecretEditableCard> {
  late TextEditingController _userIdController;
  late TextEditingController _secretController;
  late List<TextEditingController> _uriControllers;

  @override
  void initState() {
    super.initState();
    _userIdController =
        TextEditingController(text: widget.secretWrapper.secret.userId);
    _secretController =
        TextEditingController(text: widget.secretWrapper.secret.secret);
    _uriControllers = getUriControllers(widget.secretWrapper.secret.uris);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isBeingEdited = widget.secretWrapper.isBeingEdited;
    Secret secret = widget.secretWrapper.secret;
    secret.uris = secret.uris;
    _uriControllers = getUriControllers(widget.secretWrapper.secret.uris);

    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SelectableText(secret.secretId.toString()),
        TextField(
          enabled: isBeingEdited,
          controller: _userIdController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'User ID',
          ),
        ), // UserId
        SizedBox(height: 10),
        TextField(
          enabled: isBeingEdited,
          controller: _secretController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Secret',
          ),
        ), // Secret
        SizedBox(height: 10),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: secret.uris.length,
            itemBuilder: (BuildContext context, int i) {
              return Row(
                children: [
                  Expanded(
                    child: Card(
                        child: TextField(
                            enabled: isBeingEdited,
                            controller: _uriControllers[i],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'URI',
                            ))),
                  ),
                  OutlinedButton(onPressed: (){deleteUriButtonOnPressed(i);}, child: Text(globals.deleteUriButton))
                ],
              );
            }), // URIS
        OutlinedButton(
          onPressed: () {
            addUriButtonOnPressed();
          },
          child: Text(globals.addUriButton),
        ), // Add URI Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isBeingEdited)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.secretWrapper.isBeingEdited = true;
                  });
                },
                child: Text(globals.editButton),
              ), // Edit
            SizedBox(width: 10),
            if (!isBeingEdited)
              OutlinedButton(
                onPressed: deleteButtonOnPressed,
                child: Text(globals.deleteButton),
              ), // Delete
            SizedBox(width: 10),
            if (isBeingEdited)
              OutlinedButton(
                onPressed: () {
                  saveChanges();
                  setState(() {
                    widget.secretWrapper.isBeingEdited = false;
                  });
                },
                child: Text(globals.saveButton),
              ), // Save
            SizedBox(width: 10),
            if (isBeingEdited)
              OutlinedButton(
                onPressed: () {
                  cancelButtonOnPressed();
                },
                child: Text(globals.cancelButton),
              ), // Cancel
          ],
        ), // Buttons
      ],
    ));
  }

  void saveChanges() {
    final newSecretId = widget.secretWrapper.secret.secretId;
    final newUserId = _userIdController.value.text;
    final newSecret = _secretController.value.text;
    final List<String> newUris = [];

    for (TextEditingController uriController in _uriControllers) {
      newUris.add(uriController.value.text);
    }

    setState(() {
      widget.secretWrapper.secret = Secret(
          secretId: newSecretId,
          userId: newUserId,
          secret: newSecret,
          uris: newUris);
    });

    SecretsManager.update(widget.secretWrapper.secret);
  }

  void deleteButtonOnPressed() {
    SecretsManager.delete(widget.secretWrapper.secret.secretId);
    mainPageState.setState(() {

    });
  }

  void cancelButtonOnPressed() {}

  void addUriButtonOnPressed() {
    Secret secret = widget.secretWrapper.secret;
    setState(() {
      secret.uris.add("");
    });
    SecretsManager.update(secret);
  }

  void deleteUriButtonOnPressed(int i) {
    Secret secret = widget.secretWrapper.secret;
    setState(() {
      secret.uris.removeAt(i);
    });
    SecretsManager.update(secret);
  }

  List<TextEditingController> getUriControllers(List<String> uris) {
    List<TextEditingController> result = [];

    for (String uri in uris) {
      TextEditingController uriController = TextEditingController(text: uri);
      result.add(uriController);
    }

    return result;
  }
}
