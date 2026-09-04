
import 'package:get/get.dart';
import 'package:to_let_app_abandon/screens/masaage/massage_details/view/massage_details_view.dart';

class MessagesController extends GetxController {

  final selectedTabIndex = 0.obs;
  final selectedNavIndex = 2.obs;


  final List<String> tabs = [
    'All',
    'Unread',
    'System',
  ];


  final List<MessageTileData> messages = [
    MessageTileData(
      avatar: 'https://i.pravatar.cc/150?img=12',
      badgeCount: '2',
      title: 'Rahman, Owner',
      time: '2 min',
      message: 'The property is available...',
      tag: 'Sunlit 2BHK',
      showDot: true,
      isSystem: false,
    ),
    MessageTileData(
      avatar: 'https://i.pravatar.cc/150?img=47',
      badgeCount: '1',
      title: 'Ayesha Khan',
      time: '1 hour',
      message: 'I\'m interested in the...',
      tag: 'Modern House',
      showDot: true,
      isSystem: false,
    ),
    MessageTileData(
      avatar: null,
      badgeCount: null,
      title: 'Basa System',
      time: '3 hours',
      message: 'Your listing has been approved.',
      tag: 'System Alert',
      showDot: false,
      isSystem: true,
    ),
  ];


  List<MessageTileData> get filteredMessages {
    switch (selectedTabIndex.value) {
      case 1:
        return messages.where((msg) => msg.showDot).toList();
      case 2:
        return messages.where((msg) => msg.isSystem).toList();
      default:
        return messages;
    }
  }


  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }


  void navigateToMessageDetail(MessageTileData message) {
    Get.to(() => ChatDetailScreen(message: message));


  }


  void navigateToSupport() {


  }


  void goBack() {
    Get.back();
  }


  int get unreadCount {
    return messages.where((msg) => msg.showDot).length;
  }
}


class MessageTileData {
  final String? avatar;
  final String? badgeCount;
  final String title;
  final String time;
  final String message;
  final String tag;
  final bool showDot;
  final bool isSystem;

  MessageTileData({
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