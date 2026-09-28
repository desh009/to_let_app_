class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String messageText;
  final String messageType;
  final bool isRead;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    this.messageType = 'text',
    this.isRead = false,
    required this.createdAt,
  });

  String get content => messageText;

  String get time =>
      '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

  bool isMine([String? currentUserId, String? otherUserId]) {
    if (currentUserId != null && currentUserId.isNotEmpty) {
      return senderId == currentUserId;
    }

    if (otherUserId != null && otherUserId.isNotEmpty) {
      return senderId != otherUserId;
    }

    return false;
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      conversationId:
      json['conversationId']?.toString() ??
          json['conversation_id']?.toString() ??
          '',
      senderId:
      json['senderId']?.toString() ??
          json['sender_id']?.toString() ??
          '',
      receiverId:
      json['receiverId']?.toString() ??
          json['receiver_id']?.toString() ??
          '',
      messageText:
      json['messageText']?.toString() ??
          json['message_text']?.toString() ??
          '',
      messageType:
      json['messageType']?.toString() ??
          json['message_type']?.toString() ??
          'text',
      isRead: json['isRead'] ?? json['is_read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ??
          DateTime.now()
          : json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ??
          DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'receiverId': receiverId,
      'messageText': messageText,
      'messageType': messageType,
    };
  }
}