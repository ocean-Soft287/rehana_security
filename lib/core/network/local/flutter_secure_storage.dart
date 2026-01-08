import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  static const String token = "token";
  static const String mobile = "mobile";
  static const String email = "email";
  static const String name = "name";
  static const String customerid = "customer_id";
  static const String image = "image";
  static const String password = "password";
  static const String rememberme = "rememberme";

  static Future<void> write(dynamic key, String value) async {
    await _storage.write(key: key.toString(), value: value);
  }

  static Future<String?> read(dynamic key) async {
    return await _storage.read(key: key.toString());
  }

  static Future<void> delete(dynamic key) async {
    await _storage.delete(key: key.toString());
  }

  static Future<bool> containsKey(dynamic key) async {
    return await _storage.containsKey(key: key.toString());
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // دالة مساعدة للحصول على التوكن
  static Future<String?> getToken() async {
    return await _storage.read(key: token);
  }
}
