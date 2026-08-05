import 'package:kuemele/shared/utils/conversion_utils.dart';

class NotificationModel {
  const NotificationModel({
    required this.notificationId,
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    this.createdAt,
    this.readStatus = false,
    this.targetReference = const {},
    this.category = '',
  });

  final String notificationId;
  final String type;
  final String title;
  final String message;
  final String icon;
  final DateTime? createdAt;
  final bool readStatus;
  final Map<String, dynamic> targetReference;
  final String category;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final targetReference = json['target_reference'] ?? json['targetReference'];

    return NotificationModel(
      notificationId: ConversionUtils.toStringValue(
        json['notification_id'] ?? json['notificationId'] ?? json['id'],
      ),
      type: ConversionUtils.toStringValue(json['type']),
      title: ConversionUtils.toStringValue(json['title']),
      message: ConversionUtils.toStringValue(json['message']),
      icon: ConversionUtils.toStringValue(json['icon']),
      createdAt: ConversionUtils.parseDateTime(
        json['created_at'] ?? json['createdAt'],
      ),
      readStatus: json['read_status'] == true || json['readStatus'] == true,
      targetReference: targetReference is Map
          ? Map<String, dynamic>.from(targetReference)
          : const {},
      category: ConversionUtils.toStringValue(json['category']),
    );
  }
}
