// screens/chat/controllers/chat_controller.dart
import 'package:get/get.dart';

class ChatController extends GetxController {
  // Observables
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxString inputMessage = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    // Sample messages
    messages.assignAll([
      ChatMessage(
        message: "Hi! Thanks for your interest in the apartment. When would you like to visit?",
        time: "10:24 AM",
        isSentByMe: false,
      ),
      ChatMessage(
        message: "Hello, is it available for tomorrow? I'd love to check it out.",
        time: "10:26 AM",
        isSentByMe: true,
      ),
      ChatMessage(
        message: "Yes, available for visit tomorrow? Let me know time that works for you.",
        time: "10:28 AM",
        isSentByMe: false,
      ),
    ]);
  }

  void sendMessage() {
    if (inputMessage.value.trim().isEmpty) return;
    
    final now = DateTime.now();
    final time = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    
    messages.add(ChatMessage(
      message: inputMessage.value.trim(),
      time: time,
      isSentByMe: true,
    ));
    
    inputMessage.value = '';
  }

  void updateInputMessage(String value) {
    inputMessage.value = value;
  }

  void goBack() {
    Get.back();
  }
}

class ChatMessage {
  final String message;
  final String time;
  final bool isSentByMe;

  ChatMessage({
    required this.message,
    required this.time,
    required this.isSentByMe,
  });
}