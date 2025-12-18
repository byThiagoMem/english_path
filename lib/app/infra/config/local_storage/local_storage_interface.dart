///
/// Utility class to save data in local storage
///
abstract class ILocalStorage {
  ///
  /// Save [Json] value in local storage
  ///
  Future<void> setStorageData(String key, Object value);

  ///
  /// Save [Json List] value in local storage
  ///
  Future<void> setStorageDataList(String key, List<Object> values);

  ///
  /// Save [int] value in local storage
  ///
  Future<void> setStorageInt(String key, int value);

  ///
  /// Save [bool] value in local storage
  ///
  Future<void> setStorageBool(String key, bool value);

  ///
  /// Get [Json] value in local storage
  ///
  Future<dynamic> getStorageData(String key);

  ///
  /// Get [Json List] value in local storage
  ///
  Future<dynamic> getStorageDataList(String key);

  ///
  /// Get [int] value in local storage
  ///
  Future<int?> getStorageInt(String key);

  ///
  /// Get [bool] value in local storage
  ///
  Future<bool?> getStorageBool(String key);

  ///
  /// Remove local storage
  ///
  Future<void> removeStorage(String key);

  ///
  /// Remove all  storage
  ///
  Future<void> removeAll();
}

class LocalStorageKeys {
  /// [Path]
  static const String path = 'path_with_progress';
}
