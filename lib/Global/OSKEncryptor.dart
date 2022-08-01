import 'package:encrypt/encrypt.dart';

class OSKEncryptor  {

  static String encrypt(final plainText, final keyText)
  {
    final iv = IV.fromLength(16);
    final key = Key.fromUtf8(keyText.padRight(32));
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  static String decrypt(encryptedText, final keyText)
  {
    final iv = IV.fromLength(16);
    final key = Key.fromUtf8(keyText.padRight(32));
    final encrypter = Encrypter(AES(key));
    return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv).toString();
  }

}