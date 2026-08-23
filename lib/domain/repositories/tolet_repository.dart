import '../entities/tolet_item.dart';

abstract class ToLetRepository {
  Future<List<ToLetItem>> getProperties();
  Future<ToLetItem?> getPropertyById(String id);
  Future<List<String>> getFavorites();
  Future<void> toggleFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<void> saveSearchQuery(String query);
  Future<String?> getLastSearchQuery();
}
