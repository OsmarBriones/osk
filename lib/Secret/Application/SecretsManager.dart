import 'dart:convert';
import 'dart:math';
import 'package:untitled/Secret/Infrastructure/SecretsDao.dart';
import '../Domain/Secret.dart';
import '../Infrastructure/Pages/SecretsMainPage.dart';
import '../../Global/OSKGlobals.dart' as globals;
import '../../Global/OSKEncryptor.dart';

class SecretsManager {

  static Future<void> initData() async {

    String secretsJson = await SecretsDao.read();
    secretsJson = OSKEncryptor.decrypt(secretsJson, globals.masterSecret);
    print("Reading from file: $secretsJson");
    globals.secrets = toSecretsObject(secretsJson);

  }

  static List<Secret> toSecretsObject(String secretsJson) {

    List<Secret> result = [];

    var secrets = jsonDecode(secretsJson);
    assert(secrets is List);

    secrets.forEach(
      (secret) {
        assert(secret is Map<String, dynamic>);

        result.add(Secret(
          secretId: secret["secretId"],
          userId: secret["userId"],
          secret: secret["secret"],
          uris: secret["uris"].cast<String>()
        ));
      }
    );

    return result;
  }

  static SecretsMainPage getMainScreen () {
    return SecretsMainPage(title: "Secrets", secrets: globals.secrets);
  }

  static void update(Secret secret) {
    final i = globals.secrets.indexWhere((element) => element.secretId == secret.secretId);
    globals.secrets[i] = secret;
    final secretJson = jsonEncode(globals.secrets);
    SecretsDao.save(OSKEncryptor.encrypt(secretJson, globals.masterSecret));
  }

  static Secret create({List<String>? uri}) {
    uri = uri ??= [];
    Secret newSecret = Secret(secretId: _getNewId(), userId: globals.userId, secret: _getNewSecret(), uris: uri);
    globals.secrets.add(newSecret);
    _saveToFile();
    return newSecret;
  }

  static void _saveToFile() {
    final secretJson = jsonEncode(globals.secrets);
    SecretsDao.save(OSKEncryptor.encrypt(secretJson, globals.masterSecret));
  }

  static int _getNewId() {

    bool newIdExists = true;
    int newId = globals.secrets[globals.secrets.length-1].secretId;
    do {
      newId++;
      newIdExists = globals.secrets.indexWhere((element) => element.secretId == newId) != -1;
    } while (newIdExists);

    return newId;
  }

  static String _getNewSecret() {
    var r = Random();
    return String.fromCharCodes(List.generate(globals.passwordLength, (index) => r.nextInt(33) + 89));
  }

  static List<Secret> delete(int secretId) {
    final i = globals.secrets.indexWhere((element) => element.secretId == secretId);
    globals.secrets.removeAt(i);
    _saveToFile();
    return globals.secrets;
  }

  static String getSecret(String searchedUri) {

    String result = "{}";

    for(Secret secret in globals.secrets) {
      for(String uri in secret.uris) {
        if(uri.contains(searchedUri)) { result = jsonEncode(secret); }
      }
    }

    return result;
  }

}