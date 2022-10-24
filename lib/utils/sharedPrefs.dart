import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  bool? getBool(String key) {
    return _sharedPrefs.getBool(key);
  }

  String? getString(String key) {
    return _sharedPrefs.getString(key);
  }

  void setString(String key, String value){
    _sharedPrefs.setString(key, value);
  }

  void setBool(String key, bool value){
    _sharedPrefs.setBool(key, value);
  }

}