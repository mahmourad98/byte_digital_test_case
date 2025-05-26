// ignore_for_file: constant_identifier_names
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static const ACCESS_TOKEN = 'access_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ACCESS_TOKEN);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ACCESS_TOKEN);
  }
}