import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';
import '../../domain/entities/tolet_item.dart';
import '../models/listing_model.dart';

class FavoritesRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  /// Fetch all saved/favorited listings for the authenticated user
  Future<NetworkResponse> getFavorites({
    int offset = 0,
    int limit = 50,
  }) async {
    return await _networkService.get(
      Urls.favorites,
      queryParams: {'offset': offset, 'limit': limit},
    );
  }

  /// Parse favorites response into List<ToLetItem>
  List<ToLetItem> parseFavoritesList(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        final list = response.responseData!['data'] as List<dynamic>? ?? [];
        return list.map((item) {
          final listing = ListingModel.fromJson(item as Map<String, dynamic>);
          return listing.toToLetItem();
        }).toList();
      } catch (e) {
        debugPrint('Error parsing favorites response: $e');
      }
    }
    return [];
  }

  /// Add listing to favorites
  Future<NetworkResponse> addFavorite(String listingId) async {
    return await _networkService.post(Urls.favoriteById(listingId));
  }

  /// Remove listing from favorites
  Future<NetworkResponse> removeFavorite(String listingId) async {
    return await _networkService.delete(Urls.favoriteById(listingId));
  }

  /// Check if a listing is favorited
  Future<bool> checkFavorite(String listingId) async {
    try {
      final response = await _networkService.get(Urls.checkFavorite(listingId));
      if (response.isSuccess && response.responseData != null) {
        return response.responseData!['isFavorited'] == true;
      }
    } catch (e) {
      debugPrint('Error checking favorite status: $e');
    }
    return false;
  }
}
