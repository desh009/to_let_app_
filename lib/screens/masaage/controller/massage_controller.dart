import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:to_let_app_abandon/data/repositories/messages_repo.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/view/massage_details_view.dart';

class MessagesController extends GetxController {
  final selectedTabIndex = 0.obs;
  final selectedNavIndex = 2.obs;
  final RxBool isLoading = false.obs;

  late final MessagesRepo _messagesRepo;

  MessagesController({MessagesRepo? messagesRepo}) {
    _messagesRepo = messagesRepo ??
        (Get.isRegistered<MessagesRepo>()
            ? Get.find<MessagesRepo>()
            : MessagesRepo());
  }

  final List<String> tabs = [
    'All',
    'Unread',
    'System',
  ];

  final RxList<MessageTileData> messages = <MessageTileData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  // ============================================================
  // FETCH CONVERSATIONS
  // ============================================================

  Future<void> fetchConversations() async {
    try {
      isLoading.value = true;

      debugPrint('STEP 1: Calling getConversations()');

      final response = await _messagesRepo.getConversations();

      debugPrint('STEP 2: Response received');
      debugPrint('STEP 3: isSuccess = ${response.isSuccess}');

      if (!response.isSuccess) {
        debugPrint('❌ Conversations API failed');
        return;
      }

      debugPrint('STEP 4: Calling parseConversations()');

      final convs = _messagesRepo.parseConversations(response);

      debugPrint('STEP 5: Conversations count = ${convs.length}');

      if (convs.isEmpty) {
        debugPrint('ℹ️ No conversations found');
        messages.clear();
        return;
      }

      final liveTiles = convs.map((c) {
        debugPrint('STEP 6: Processing message/conversation ID: ${c.conversationId}');

        return MessageTileData(
          conversationId: c.conversationId,
          otherUserId: c.senderId, // fallbacks or sender ID
          avatar: 'https://i.pravatar.cc/150?img=12', // default or custom placeholder

          badgeCount: !c.isRead ? '1' : null,

          title: 'User (${c.senderId.substring(0, math.min(c.senderId.length, 5))})',

          time: c.time,

          message: c.messageText,

          tag: 'Direct Chat',

          showDot: !c.isRead,

          isSystem: c.messageType == 'system',
        );
      }).toList();

      debugPrint(
        'STEP 7: Assigning ${liveTiles.length} messages',
      );

      messages.assignAll(liveTiles);
    } catch (e, stackTrace) {
      debugPrint('❌ ERROR fetching conversations: $e');
      debugPrint('❌ STACK TRACE: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<MessageTileData> get filteredMessages {
    switch (selectedTabIndex.value) {
      case 1:
        return messages
            .where((msg) => msg.showDot)
            .toList();

      case 2:
        return messages
            .where((msg) => msg.isSystem)
            .toList();

      default:
        return messages.toList();
    }
  }

  // ============================================================
  // TAB
  // ============================================================

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // ============================================================
  // MESSAGE DETAIL
  // ============================================================

  void navigateToMessageDetail(MessageTileData message) {
    Get.to(
          () => ChatDetailScreen(
        message: message,
      ),
    );
  }

  // ============================================================
  // SUPPORT
  // ============================================================

  void navigateToSupport() {
    // TODO: Add support screen navigation
  }

  // ============================================================
  // BACK
  // ============================================================

  void goBack() {
    Get.back();
  }

  // ============================================================
  // UNREAD COUNT
  // ============================================================

  int get unreadCount {
    return messages.where((msg) => msg.showDot).length;
  }
}

// ================================================================
// MESSAGE TILE DATA
// ================================================================

class MessageTileData {
  final String? conversationId;
  final String? otherUserId;
  final String? avatar;
  final String? badgeCount;

  final String title;
  final String time;
  final String message;
  final String tag;

  final bool showDot;
  final bool isSystem;

  MessageTileData({
    this.conversationId,
    this.otherUserId,
    this.avatar,
    this.badgeCount,
    required this.title,
    required this.time,
    required this.message,
    required this.tag,
    required this.showDot,
    this.isSystem = false,
  });
}