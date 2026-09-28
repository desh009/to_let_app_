import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/data/models/listing_model.dart';
import 'package:to_let_app_abandon/data/repositories/listings_repo.dart';
import 'package:to_let_app_abandon/domain/entities/tolet_item.dart';

class MyListingsController extends GetxController {
  final ListingsRepo _listingsRepo = ListingsRepo();

  final RxList<ToLetItem> myListings = <ToLetItem>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<PaginationModel?> pagination = Rx<PaginationModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchMyListings();
  }

  Future<void> fetchMyListings() async {
    try {
      isLoading.value = true;
      final response = await _listingsRepo.getMyListings(offset: 0, limit: 50);

      if (response.isSuccess) {
        final listingsResponse = _listingsRepo.parseListingsResponse(response);
        if (listingsResponse != null) {
          myListings.assignAll(
            listingsResponse.data.map((e) => e.toToLetItem()).toList(),
          );
          pagination.value = listingsResponse.pagination;
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to load your listings',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error fetching my listings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      final response = await _listingsRepo.deleteListing(id);
      if (response.isSuccess) {
        myListings.removeWhere((item) => item.id == id);
        Get.snackbar(
          'Success',
          'Listing deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to delete listing',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error deleting listing: $e');
    }
  }

  void navigateToDetails(ToLetItem item) {
    Get.toNamed('/details', arguments: item);
  }
}
