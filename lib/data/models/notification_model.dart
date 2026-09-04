import '../../domain/entities/tolet_item.dart';

class AppNotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;
  final String? propertyId;
  final ToLetItem? property;
  final String type;

  AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.propertyId,
    this.property,
    this.type = 'listing',
  });
}
