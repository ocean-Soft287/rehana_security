import 'dart:convert';
import 'package:encrypt/encrypt.dart';

String encryptAes(String plainText, String base64Key, String base64Iv) {
  final key = Key(base64.decode(base64Key));
  final iv = IV(base64.decode(base64Iv));

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final encrypted = encrypter.encrypt(plainText, iv: iv);

  return encrypted.base64;
}


String decryptAes(String base64CipherText, String base64Key, String base64Iv) {
  final key = Key(base64.decode(base64Key));
  final iv = IV(base64.decode(base64Iv));

  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
  final encrypted = Encrypted.fromBase64(base64CipherText);

  return encrypter.decrypt(encrypted, iv: iv);
}