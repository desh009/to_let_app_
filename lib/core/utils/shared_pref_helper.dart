import 'package:get/get.dart';
import '../constants/storage_keys.dart';
import '../services/storage_service.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static StorageService get _service => Get.find<StorageService>();

  // ================= Generic Helpers =================
  static String? getString(String key) => _service.getString(key);
  static Future<bool> setString(String key, String value) => _service.setString(key, value);

  static bool? getBool(String key) => _service.getBool(key);
  static Future<bool> setBool(String key, bool value) => _service.setBool(key, value);

  static int? getInt(String key) => _service.getInt(key);
  static Future<bool> setInt(String key, int value) => _service.setInt(key, value);

  static double? getDouble(String key) => _service.getDouble(key);
  static Future<bool> setDouble(String key, double value) => _service.setDouble(key, value);

  static List<String>? getStringList(String key) => _service.getStringList(key);
  static Future<bool> setStringList(String key, List<String> value) => _service.setStringList(key, value);

  static bool hasKey(String key) => _service.hasKey(key);
  static Future<bool> remove(String key) => _service.remove(key);
  static Future<bool> clearAll() => _service.clear();

  // ================= Feature / Business Helpers =================

  /// App First Launch Check
  static bool isFirstTimeLaunch() {
    return _service.getBool(StorageKeys.isFirstTime) ?? true;
  }

  static Future<void> setFirstTimeLaunch(bool value) async {
    await _service.setBool(StorageKeys.isFirstTime, value);
  }

  /// Theme (Dark Mode / Light Mode)
  static bool isDarkMode() {
    return _service.getBool(StorageKeys.isDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await _service.setBool(StorageKeys.isDarkMode, value);
  }

  /// User Profile & Authentication
  static String? getUserToken() {
    return _service.getString(StorageKeys.userToken);
  }

  static Future<void> setUserToken(String token) async {
    await _service.setString(StorageKeys.userToken, token);
  }

  static bool isLoggedIn() {
    final token = getUserToken();
    return token != null && token.isNotEmpty;
  }

  static String getUserName() {
    return _service.getString(StorageKeys.userName) ?? 'Guest User';
  }

  static Future<void> setUserName(String name) async {
    await _service.setString(StorageKeys.userName, name);
  }

  static String getUserPhone() {
    return _service.getString(StorageKeys.userPhone) ?? '';
  }

  static Future<void> setUserPhone(String phone) async {
    await _service.setString(StorageKeys.userPhone, phone);
  }

  /// Favorites List
  static List<String> getFavoriteProperties() {
    return _service.getStringList(StorageKeys.favoriteProperties) ?? [];
  }

  static Future<void> setFavoriteProperties(List<String> favorites) async {
    await _service.setStringList(StorageKeys.favoriteProperties, favorites);
  }

  /// Search History / Query
  static String? getLastSearchQuery() {
    return _service.getString(StorageKeys.savedSearchQuery);
  }

  static Future<void> saveLastSearchQuery(String query) async {
    await _service.setString(StorageKeys.savedSearchQuery, query);
  }

  /// Logout / Clear User Session
  static Future<void> clearUserSession() async {
    await _service.remove(StorageKeys.userToken);
    await _service.remove(StorageKeys.userName);
    await _service.remove(StorageKeys.userPhone);
  }
}
