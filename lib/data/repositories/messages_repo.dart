import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../core/config/urls.dart';
import '../../core/network/network_response.dart';
import '../../core/services/network_service.dart';
import '../models/chat_model.dart';

class MessagesRepo {
  final NetworkService _networkService = Get.find<NetworkService>();

  /// Fetch user conversations list
  Future<NetworkResponse> getConversations({String filter = 'all'}) async {
    return await _networkService.get(
      Urls.conversations,
      queryParams: filter != 'all' ? {'filter': filter} : null,
    );
  }

  /// Parse conversations list
  List<ChatMessageModel> parseConversations(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        final list = response.responseData!['data'] as List<dynamic>? ?? [];
        return list
            .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error parsing conversations: $e');
      }
    }
    return [];
  }

  /// Fetch messages for a conversation
  Future<NetworkResponse> getMessages(String conversationId) async {
    return await _networkService.get(
      Urls.messagesByConversation(conversationId),
    );
  }

  /// Parse messages list
  List<ChatMessageModel> parseMessages(NetworkResponse response) {
    if (response.isSuccess && response.responseData != null) {
      try {
        final list = response.responseData!['data'] as List<dynamic>? ?? [];
        return list
            .map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error parsing messages: $e');
      }
    }
    return [];
  }

  /// Send message
  Future<NetworkResponse> sendMessage({
    required String conversationId,
    required String receiverId,
    required String messageText,
    String messageType = 'text',
  }) async {
    return await _networkService.post(
      Urls.sendMessage,
      body: {
        'conversationId': conversationId,
        'receiverId': receiverId,
        'messageText': messageText,
        'messageType': messageType,
      },
    );
  }

  /// Start or get conversation with seller or user
  Future<NetworkResponse> startConversation({
    int? listingId,
    String? sellerId,
    String? otherUserId,
  }) async {
    final body = <String, dynamic>{};
    if (listingId != null) body['listingId'] = listingId;
    if (sellerId != null) body['sellerId'] = sellerId;
    if (otherUserId != null) body['otherUserId'] = otherUserId;

    return await _networkService.post(Urls.conversations, body: body);
  }

  /// Search users to start new conversation
  Future<NetworkResponse> searchUsers(String query) async {
    return await _networkService.get(
      Urls.searchUsers,
      queryParams: {'q': query, 'limit': 20},
    );
  }
}
