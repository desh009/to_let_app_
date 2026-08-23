import '../../domain/entities/tolet_item.dart';
import '../../domain/repositories/tolet_repository.dart';
import '../datasources/tolet_local_datasource.dart';

class ToLetRepositoryImpl implements ToLetRepository {
  final ToLetLocalDataSource localDataSource;

  ToLetRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ToLetItem>> getProperties() async {
    return await localDataSource.getProperties();
  }

  @override
  Future<ToLetItem?> getPropertyById(String id) async {
    final properties = await localDataSource.getProperties();
    try {
      return properties.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getFavorites() async {
    return await localDataSource.getFavoriteIds();
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final currentFavorites = await localDataSource.getFavoriteIds();
    final updatedList = List<String>.from(currentFavorites);
    if (updatedList.contains(id)) {
      updatedList.remove(id);
    } else {
      updatedList.add(id);
    }
    await localDataSource.saveFavoriteIds(updatedList);
  }

  @override
  Future<bool> isFavorite(String id) async {
    final favorites = await localDataSource.getFavoriteIds();
    return favorites.contains(id);
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    await localDataSource.saveLastSearch(query);
  }

  @override
  Future<String?> getLastSearchQuery() async {
    return await localDataSource.getLastSearch();
  }
}
