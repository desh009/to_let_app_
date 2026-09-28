import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_let_app_abandon/data/repositories/messages_repo.dart';
import 'package:to_let_app_abandon/screens/masaage/controller/massage_controller.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/view/massage_details_view.dart';

class UserSearchController extends GetxController {
  final MessagesRepo _messagesRepo = MessagesRepo();
  final TextEditingController searchController = TextEditingController();
  
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  void searchUsers(String query) async {
    if (query.length < 2) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      final response = await _messagesRepo.searchUsers(query);
      if (response.isSuccess && response.responseData?['data'] != null) {
        final List<dynamic> list = response.responseData!['data'];
        searchResults.assignAll(list.map((e) => e as Map<String, dynamic>).toList());
      }
    } catch (e) {
      debugPrint('Error searching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void startConversation(Map<String, dynamic> user) async {
    try {
      final response = await _messagesRepo.startConversation(otherUserId: user['id']);
      if (response.isSuccess && response.responseData?['data'] != null) {
        final convData = response.responseData!['data'];
        final convId = convData['id']?.toString();
        
        final tileData = MessageTileData(
          conversationId: convId,
          otherUserId: user['id'],
          title: user['name'] ?? 'User',
          avatar: 'https://ui-avatars.com/api/?name=${user['name']}',
          message: 'Start a conversation...',
          time: 'Now',
          tag: 'Direct Chat',
          showDot: false,
        );

        Get.off(() => ChatDetailScreen(message: tileData));
      }
    } catch (e) {
      debugPrint('Error starting conversation: $e');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
