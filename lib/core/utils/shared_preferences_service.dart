import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences!.setString(key, value);
    } catch (e) {
      print('Error setting string: $e');
      return false;
    }
  }

  String? getString(String key, {String? defaultValue}) {
    try {
      return _preferences!.getString(key) ?? defaultValue;
    } catch (e) {
      print('Error getting string: $e');
      return defaultValue;
    }
  }

  // Integer operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences!.setInt(key, value);
    } catch (e) {
      print('Error setting int: $e');
      return false;
    }
  }

  int? getInt(String key, {int? defaultValue}) {
    try {
      return _preferences!.getInt(key) ?? defaultValue;
    } catch (e) {
      print('Error getting int: $e');
      return defaultValue;
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences!.setDouble(key, value);
    } catch (e) {
      print('Error setting double: $e');
      return false;
    }
  }

  double? getDouble(String key, {double? defaultValue}) {
    try {
      return _preferences!.getDouble(key) ?? defaultValue;
    } catch (e) {
      print('Error getting double: $e');
      return defaultValue;
    }
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences!.setBool(key, value);
    } catch (e) {
      print('Error setting bool: $e');
      return false;
    }
  }

  bool? getBool(String key, {bool? defaultValue}) {
    try {
      return _preferences!.getBool(key) ?? defaultValue;
    } catch (e) {
      print('Error getting bool: $e');
      return defaultValue;
    }
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences!.setStringList(key, value);
    } catch (e) {
      print('Error setting string list: $e');
      return false;
    }
  }

  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    try {
      return _preferences!.getStringList(key) ?? defaultValue;
    } catch (e) {
      print('Error getting string list: $e');
      return defaultValue;
    }
  }

  // Object operations (using JSON)
  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    try {
      String jsonString = json.encode(value);
      return await _preferences!.setString(key, jsonString);
    } catch (e) {
      print('Error setting object: $e');
      return false;
    }
  }

  Map<String, dynamic>? getObject(String key, {Map<String, dynamic>? defaultValue}) {
    try {
      String? jsonString = _preferences!.getString(key);
      if (jsonString != null) {
        return json.decode(jsonString) as Map<String, dynamic>;
      }
      return defaultValue;
    } catch (e) {
      print('Error getting object: $e');
      return defaultValue;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    try {
      return await _preferences!.remove(key);
    } catch (e) {
      print('Error removing key: $e');
      return false;
    }
  }

  // Clear all
  Future<bool> clear() async {
    try {
      return await _preferences!.clear();
    } catch (e) {
      print('Error clearing preferences: $e');
      return false;
    }
  }

  // Check if key exists
  bool containsKey(String key) {
    try {
      return _preferences!.containsKey(key);
    } catch (e) {
      print('Error checking key: $e');
      return false;
    }
  }

  // Get all keys
  Set<String> getAllKeys() {
    try {
      return _preferences!.getKeys();
    } catch (e) {
      print('Error getting all keys: $e');
      return <String>{};
    }
  }
}
