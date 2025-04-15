import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  static const String _ridesKey = 'rides';
  LocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<void> saveRides({required List<String> list}) async {
    await _prefs.setStringList(_ridesKey, list);
  }

  Future<List<String>> getRides() async {
    return _prefs.getStringList(_ridesKey) ?? [];
  }

  Future<void> saveString({required String key, required String value}) async {
    await _prefs.setString(key, value);
  }

  Future<String?> getString({required String key}) async {
    return _prefs.getString(key);
  }
}
