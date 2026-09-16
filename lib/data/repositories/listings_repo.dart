import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';
import '../models/filter_options_model.dart';
import '../models/listing_model.dart';

class ListingsRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  // Get Home Listings
  Future<NetworkResponse> getHomeListings({
    int offset = 0,
    int limit = 20,
    String? city,
    String? category,
    int? minPrice,
    int? maxPrice,
  }) async {
    final queryParams = <String, dynamic>{'offset': offset, 'limit': limit};

    if (city != null && city.isNotEmpty) {
      queryParams['city'] = city;
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (minPrice != null) {
      queryParams['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      queryParams['maxPrice'] = maxPrice;
    }

    return await _networkService.get(
      Urls.homeListings,
      queryParams: queryParams,
    );
  }

  // Get All Listings (from /api/listings)
  Future<NetworkResponse> getAllListings({
    int offset = 0,
    int limit = 20,
    String? city,
    String? category,
    int? minPrice,
    int? maxPrice,
  }) async {
    final queryParams = <String, dynamic>{'offset': offset, 'limit': limit};

    if (city != null && city.isNotEmpty) {
      queryParams['city'] = city;
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (minPrice != null) {
      queryParams['minPrice'] = minPrice;
    }
    if (maxPrice != null) {
      queryParams['maxPrice'] = maxPrice;
    }

    return await _networkService.get(
      Urls.allListings,
      queryParams: queryParams,
    );
  }

  // Parse Listings Response
  ListingsResponse? parseListingsResponse(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        return ListingsResponse.fromJson(response.responseData!);
      } catch (e) {
        debugPrint('Error parsing listings response: $e');
        return null;
      }
    }
    return null;
  }

  // Get Filter Options
  Future<NetworkResponse> getFilterOptions() async {
    return await _networkService.get(Urls.filterOptions);
  }

  // Parse Filter Options Response
  FilterOptionsResponse? parseFilterOptionsResponse(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        return FilterOptionsResponse.fromJson(response.responseData!);
      } catch (e) {
        debugPrint('Error parsing filter options response: $e');
        return null;
      }
    }
    return null;
  }
}
