import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../infra.dart';

///
/// Local Storage implementation with Shared Preferences package
///
class SharedPreferencesStorage implements ILocalStorage {
  late Future<SharedPreferences> _prefs;

  SharedPreferencesStorage() {
    _prefs = SharedPreferences.getInstance();
  }

  @override
  Future<void> setStorageData(String key, Object value) async =>
      (await _prefs).setString(key, jsonEncode(value));

  @override
  Future<void> setStorageDataList(String key, List<Object> values) async {
    List<String> collection = [];

    for (var element in values) {
      collection.add(jsonEncode(element));
    }

    (await _prefs).setStringList(key, collection);
  }

  @override
  Future<void> setStorageInt(String key, int value) async =>
      (await _prefs).setInt(key, value);

  @override
  Future<void> setStorageBool(String key, bool value) async =>
      (await _prefs).setBool(key, value);

  @override
  Future<dynamic> getStorageData(String key) async {
    var data = (await _prefs).getString(key);

    return data != null ? jsonDecode(data) : null;
  }

  @override
  Future<dynamic> getStorageDataList(String key) async {
    List<dynamic> collection = [];

    var data = (await _prefs).getStringList(key);

    if (data != null) {
      for (var element in data) {
        collection.add(jsonDecode(element));
      }
    }

    return collection;
  }

  @override
  Future<int?> getStorageInt(String key) async => (await _prefs).getInt(key);

  @override
  Future<bool?> getStorageBool(String key) async => (await _prefs).getBool(key);

  @override
  Future<void> removeStorage(String key) async => (await _prefs).remove(key);

  @override
  Future<void> removeAll() async => (await _prefs).clear();
}
