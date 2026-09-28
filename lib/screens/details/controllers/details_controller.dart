import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/data/models/listing_model.dart';
import 'package:to_let_app_abandon/data/repositories/listings_repo.dart';
import 'package:to_let_app_abandon/widgets/favourite/controller/favourite_controller.dart';
import 'package:to_let_app_abandon/widgets/shimmer/custom_shimmer.dart';
import '../../../domain/entities/tolet_item.dart';
import '../../masaage/massage_details/view/massage_details_view.dart';
import '../../masaage/controller/massage_controller.dart';
import '../../../data/repositories/messages_repo.dart';

class DetailsController extends GetxController {
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final ListingsRepo _listingsRepo = ListingsRepo();

  final Rx<ToLetItem?> _item = Rx<ToLetItem?>(null);
  ToLetItem get item => _item.value!;
  bool get hasItem => _item.value != null;

  final RxBool isLoading = false.obs;

  bool get isFavorite =>
      _item.value != null && favoriteController.isFavorite(_item.value!.id);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ToLetItem) {
      _item.value = Get.arguments as ToLetItem;
      // Refresh with latest data from API
      fetchListingDetails(_item.value!.id);
    }
  }

  Future<void> fetchListingDetails(String id) async {
    try {
      isLoading.value = true;
      final response = await _listingsRepo.getListingDetails(id);

      if (response.isSuccess) {
        // Note: getListingDetails endpoint returns a single object in 'data'

        final dynamic rawData = response.responseData?['data'];
        if (rawData != null) {
          final listingModel = ListingModel.fromJson(
            rawData as Map<String, dynamic>,
          );
          _item.value = listingModel.toToLetItem();
          debugPrint('LISTING DETAILS REFRESHED FROM API');
        }
      }
    } catch (e) {
      debugPrint('Error fetching listing details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // void toogleFavourite() {
  //   if (item != null && item.id.isNotEmpty) {
  //     favoriteController.toggleFavorite(item);
  //   }
  // }

  Future<void> toggleFavorite() async {
    if (_item.value != null) {
      await favoriteController.toggleFavorite(_item.value!);
    }
  }

  void contactOwner() async {
    if (_item.value == null) return;

    try {
      // Find owner ID from listing metadata (if available) or assume from response
      // For now, let's use the startConversation API to get/create a real conversation
      final messagesRepo = Get.find<MessagesRepo>();

      // Attempt to get Listing ID as int for the API
      final int? listingId = int.tryParse(item.id);

      Get.dialog(
        Center(child: CircularShimmerLoader(size: 50)),
        barrierDismissible: false,
      );

      final response = await messagesRepo.startConversation(
        listingId: listingId,
        sellerId: null, // API handles finding owner via listingId
        otherUserId: null,
      );

      Get.back(); // Close loading dialog

      if (response.isSuccess && response.responseData?['data'] != null) {
        final convData = response.responseData!['data'];
        final convId = convData['id']?.toString();
        final otherUserId = convData['seller_id']?.toString();

        final chatTile = MessageTileData(
          conversationId: convId,
          otherUserId: otherUserId,
          avatar:
              item.ownerAvatar ??
              'https://ui-avatars.com/api/?name=${item.ownerName}',
          badgeCount: null,
          title: item.ownerName,
          time: 'Now',
          message: 'Inquiry about: ${item.title}',
          tag: 'Property Chat',
          showDot: false,
        );

        Get.to(() => ChatDetailScreen(message: chatTile));
      } else {
        // Fallback if API fails
        _showFallbackChat();
      }
    } catch (e) {
      Get.back(); // Close dialog
      _showFallbackChat();
    }
  }

  void _showFallbackChat() {
    final ownerMessage = MessageTileData(
      avatar: item.ownerAvatar ?? 'https://i.pravatar.cc/150?img=12',
      title: item.ownerName,
      time: 'Now',
      message: 'Hello, I am interested in this property.',
      tag: item.title,
      showDot: false,
    );
    Get.to(() => ChatDetailScreen(message: ownerMessage));
  }
}
