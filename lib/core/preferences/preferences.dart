import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cache_constants.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._internal();
  static SharedPreferencesHelper get instance => _instance;
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();

  static SharedPreferences? __prefs;
  SharedPreferences get _prefs {
    if (!_initialized) {
      throw Exception('''
        SharedPreferencesHelper not initialized.
        Please call SharedPreferencesHelper.init() before using it.
      ''');
    }
    return __prefs!;
  }

  static bool _initialized = false;

  static Future<void> init() async {
    try {
      __prefs = await SharedPreferences.getInstance();
      _initialized = true;
    } catch (error, stackTrace) {
      Logger(
        'SharedPreferencesHelper',
      ).severe('Error initalizing', error, stackTrace);

      _initialized = false;
    }
  }

  Future<void> setString(CacheConstants key, String value) async =>
      _prefs.setString(key.key, value);

  String? getString(CacheConstants key) => _prefs.getString(key.key);

  DateTime? getDateTime(CacheConstants key) {
    final dateString = getString(key);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  Future<void> setInt(CacheConstants key, int value) async {
    await _prefs.setInt(key.key, value);
  }

  int? getInt(CacheConstants key) {
    return _prefs.getInt(key.key);
  }

  Future<void> setBool(CacheConstants key, {bool value = false}) async {
    await _prefs.setBool(key.key, value);
  }

  bool getBool(CacheConstants key) => _prefs.getBool(key.key) ?? false;

  Future<void> setStringList(CacheConstants key, List<String> value) async {
    await _prefs.setStringList(key.key, value);
  }

  List<String>? getStringList(CacheConstants key) {
    return _prefs.getStringList(key.key);
  }

  Future<void> setMap(CacheConstants key, Map<String, dynamic> value) async =>
      setString(key, jsonEncode(value));

  Map<String, dynamic>? getMap(CacheConstants key) {
    final jsonString = getString(key);
    return jsonString != null
        ? jsonDecode(jsonString) as Map<String, dynamic>
        : null;
  }

  Future<void> remove(CacheConstants key) async {
    await _prefs.remove(key.key);
  }

  Future<void> clear() async => await _prefs.clear();

  Future<bool> exists(CacheConstants key) async {
    return _prefs.get(key.key) != null;
  }
}
