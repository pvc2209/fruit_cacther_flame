import 'package:shared_preferences/shared_preferences.dart';

class SPref {
  SPref._internal();
  static final SPref instance = SPref._internal();

  Future<bool> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }
}
