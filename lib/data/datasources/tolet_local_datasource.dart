import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import '../models/tolet_model.dart';

abstract class ToLetLocalDataSource {
  Future<List<ToLetModel>> getProperties();
  Future<List<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<String> ids);
  Future<void> saveLastSearch(String query);
  Future<String?> getLastSearch();
}

class ToLetLocalDataSourceImpl implements ToLetLocalDataSource {
  final StorageService storageService;

  ToLetLocalDataSourceImpl({required this.storageService});

  @override
  Future<List<ToLetModel>> getProperties() async {
    // In local demo, return rich sample listings
    return ToLetModel.sampleData;
  }

  @override
  Future<List<String>> getFavoriteIds() async {
    return storageService.getStringList(StorageKeys.favoriteProperties) ?? [];
  }

  @override
  Future<void> saveFavoriteIds(List<String> ids) async {
    await storageService.setStringList(StorageKeys.favoriteProperties, ids);
  }

  @override
  Future<void> saveLastSearch(String query) async {
    await storageService.setString(StorageKeys.savedSearchQuery, query);
  }

  @override
  Future<String?> getLastSearch() async {
    return storageService.getString(StorageKeys.savedSearchQuery);
  }
}
