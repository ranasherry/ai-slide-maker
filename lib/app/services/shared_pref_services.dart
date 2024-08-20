import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static final SharedPrefService _instance = SharedPrefService._internal();

  factory SharedPrefService() {
    return _instance;
  }

  SharedPrefService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save a string value
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Get a string value
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save an int value
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // Get an int value
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Save a boolean value
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Get a boolean value
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Remove a specific key
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _prefs.clear();
  }

  String? getGender() {
    String? gender = _prefs.getString('selectedGender');
    return gender;
  }

  Future<void> setGender(String gender) async {
    await _prefs.setString('selectedGender', gender);
  }

  String? getProfession() {
    String? p = _prefs.getString('selectedProfession');
    return p;
  }

  Future<void> setProfession(String p) async {
    await _prefs.setString('selectedProfession', p);
  }
}
