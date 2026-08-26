// core/services/storage_service.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  /// Initialize SharedPreferences instance
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // String
  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  // Bool
  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  // Int
  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  // Double
  double? getDouble(String key) => _prefs.getDouble(key);
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  // List of Strings
  List<String>? getStringList(String key) => _prefs.getStringList(key);
  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);

  // ============ ✅ FAVORITE PROPERTIES ============
  
  /// Get favorite property IDs
  List<String> get favoriteProperties {
    return _prefs.getStringList(StorageKeys.favoriteProperties) ?? [];
  }

  /// Set favorite property IDs
  Future<bool> setFavoriteProperties(List<String> ids) async {
    return await _prefs.setStringList(StorageKeys.favoriteProperties, ids);
  }

  /// Add a single favorite ID
  Future<bool> addFavorite(String id) async {
    final current = favoriteProperties;
    if (!current.contains(id)) {
      current.add(id);
      return await setFavoriteProperties(current);
    }
    return true;
  }

  /// Remove a single favorite ID
  Future<bool> removeFavorite(String id) async {
    final current = favoriteProperties;
    if (current.contains(id)) {
      current.remove(id);
      return await setFavoriteProperties(current);
    }
    return true;
  }

  /// Check if ID is favorite
  bool isFavorite(String id) {
    return favoriteProperties.contains(id);
  }

  /// Get favorite count
  int get favoriteCount {
    return favoriteProperties.length;
  }

  // Check key exists
  bool hasKey(String key) => _prefs.containsKey(key);

  // Remove
  Future<bool> remove(String key) => _prefs.remove(key);

  // Clear all
  Future<bool> clear() => _prefs.clear();
}