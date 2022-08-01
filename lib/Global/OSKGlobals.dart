library globals;

import '../Secret/Domain/Secret.dart';

const secretsFileName = "secrets.osk";

const userId = "osmar123";
const masterSecret = "19078505323934t6890e349";

const deleteButton = "Delete";
const deleteUriButton = "-";
const addUriButton = "+";
const editButton = "Edit";
const saveButton = "Save";
const cancelButton = "Cancel";
const okButton = "Ok";
const noButton = "No";

String gettingSecretMessage({required final connectionInfo, required final uriRequested}) {
  DateTime now = DateTime.now();
  final currentTime = "${now.hour}:${now.minute}";
  return "Request from $connectionInfo, triying to get secret of $uriRequested at $currentTime, do you approve?";
}

String addingSecretMessage({required final connectionInfo, required final uriRequested}) {
  DateTime now = DateTime.now();
  final currentTime = "${now.hour}:${now.minute}";
  return "Request from $connectionInfo, triying to add a new secret for $uriRequested at $currentTime, do you agree?";
}

List<Secret> secrets = [];

const passwordLength = 30;