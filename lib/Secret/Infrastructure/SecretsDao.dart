import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../../Global/OSKGlobals.dart' as globals;

class SecretsDao {

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final localPath = await _localPath;
    return File(path.join(localPath, globals.secretsFileName));
  }

  static Future<File> save(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  static Future<String> read() async {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents;
  }
}