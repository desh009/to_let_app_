
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;


  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }


  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);


  bool? getBool(String key) => _prefs.getBool(key);
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);


  int? getInt(String key) => _prefs.getInt(key);
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);


  double? getDouble(String key) => _prefs.getDouble(key);
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);


  List<String>? getStringList(String key) => _prefs.getStringList(key);
  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);


  List<String> get favoriteProperties {
    return _prefs.getStringList(StorageKeys.favoriteProperties) ?? [];
  }


  Future<bool> setFavoriteProperties(List<String> ids) async {
    return await _prefs.setStringList(StorageKeys.favoriteProperties, ids);
  }


  Future<bool> addFavorite(String id) async {
    final current = favoriteProperties;
    if (!current.contains(id)) {
      current.add(id);
      return await setFavoriteProperties(current);
    }
    return true;
  }


  Future<bool> removeFavorite(String id) async {
    final current = favoriteProperties;
    if (current.contains(id)) {
      current.remove(id);
      return await setFavoriteProperties(current);
    }
    return true;
  }


  bool isFavorite(String id) {
    return favoriteProperties.contains(id);
  }


  int get favoriteCount {
    return favoriteProperties.length;
  }


  bool hasKey(String key) => _prefs.containsKey(key);


  Future<bool> remove(String key) => _prefs.remove(key);


  Future<bool> clear() => _prefs.clear();
}