import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';

import '../models/filter_options_model.dart';
import '../models/listing_model.dart';

class ListingsRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  // ============================================================
  // HOME LISTINGS
  // ============================================================

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

  // ============================================================
  // ALL LISTINGS WITH FILTERS
  // ============================================================

  Future<NetworkResponse> getAllListings({
    int offset = 0,
    int limit = 20,
    String? search,
    String? city,
    String? area,
    String? category,
    int? minPrice,
    int? maxPrice,
    int? bedrooms,
    String? furnishing,
    String? availability,
    Map<String, bool>? amenities,
  }) async {
    final queryParams = <String, dynamic>{'offset': offset, 'limit': limit};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    // ---------------- LOCATION ----------------

    if (city != null && city.isNotEmpty) {
      queryParams['city'] = city;
    }

    if (area != null && area.isNotEmpty) {
      queryParams['area'] = area;
    }

    // ---------------- CATEGORY ----------------

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    // ---------------- PRICE ----------------

    if (minPrice != null) {
      queryParams['minPrice'] = minPrice;
    }

    if (maxPrice != null) {
      queryParams['maxPrice'] = maxPrice;
    }
    debugPrint('GET ALL LISTINGS QUERY: $queryParams');
    // ---------------- BEDROOM ----------------

    if (bedrooms != null) {
      queryParams['bedrooms'] = bedrooms;
    }

    // ---------------- FURNISHING ----------------

    if (furnishing != null && furnishing.isNotEmpty) {
      queryParams['furnishing'] = furnishing;
    }

    // ---------------- AVAILABILITY ----------------

    if (availability != null && availability.isNotEmpty) {
      queryParams['availability'] = availability;
    }

    // ---------------- AMENITIES ----------------
    //
    // Backend expects:
    //
    // amenities.lift=true
    // amenities.parking=true
    // amenities.generator=true
    //
    // So we send them exactly like that.

    if (amenities != null && amenities.isNotEmpty) {
      amenities.forEach((key, value) {
        if (value == true) {
          queryParams['amenities.$key'] = 'true';
        }
      });
    }

    debugPrint('GET ALL LISTINGS QUERY: $queryParams');

    return await _networkService.get(
      Urls.allListings,
      queryParams: queryParams,
    );
  }

  // ============================================================
  // PARSE LISTINGS
  // ============================================================

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

  // ============================================================
  // FILTER OPTIONS
  // ============================================================

  Future<NetworkResponse> getFilterOptions() async {
    return await _networkService.get(Urls.filterOptions);
  }

  // ============================================================
  // PARSE FILTER OPTIONS
  // ============================================================

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

  // ============================================================
  // CREATE LISTING
  // ============================================================

  Future<NetworkResponse> createListing(Map<String, dynamic> data) async {
    return await _networkService.post(Urls.allListings, body: data);
  }

  // ============================================================
  // UPDATE LISTING
  // ============================================================

  Future<NetworkResponse> updateListing(
    String id,
    Map<String, dynamic> data,
  ) async {
    return await _networkService.put('${Urls.allListings}/$id', body: data);
  }

  // ============================================================
  // DELETE LISTING
  // ============================================================

  Future<NetworkResponse> deleteListing(String id) async {
    return await _networkService.delete('${Urls.allListings}/$id');
  }

  // ============================================================
  // MY LISTINGS
  // ============================================================

  Future<NetworkResponse> getMyListings({int offset = 0, int limit = 20}) async {
    return await _networkService.get(
      Urls.myListings,
      queryParams: {'offset': offset, 'limit': limit},
    );
  }

  // ============================================================
  // GET LISTING DETAILS
  // ============================================================

  Future<NetworkResponse> getListingDetails(String id) async {
    return await _networkService.get(Urls.listingById(id));
  }

  // ============================================================
  // UPLOAD IMAGES
  // ============================================================

  Future<NetworkResponse> uploadPropertyImages(List<String> base64Images) async {
    return await _networkService.post(
      Urls.uploadImages,
      body: {'images': base64Images},
    );
  }
}
