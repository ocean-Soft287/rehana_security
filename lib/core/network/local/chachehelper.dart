// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Save boolean data
  static Future<bool> putData({required String key, required bool value}) async {
    return await sharedPreferences.setBool(key, value);
  }

  static Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else {
      throw Exception("Invalid value type");
    }
  }

  /// Retrieve data by key
  static dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

  /// Remove data by key
  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

  /// Clear all stored data
  static Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }




}