import 'package:equatable/equatable.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_config.dart';

class CreateSupportTicketRequest extends Equatable {
  const CreateSupportTicketRequest({
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
    this.attachmentUrls = const [],
    this.relatedEntityId,
    this.relatedEntityType,
  });

  final String subject;
  final String description;
  final SupportTicketCategory category;
  final SupportTicketPriority priority;
  final List<String> attachmentUrls;
  final String? relatedEntityId;
  final String? relatedEntityType;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'subject': subject,
      'description': description,
      'category': category.apiValue,
      'priority': priority.apiValue,
    };

    if (attachmentUrls.isNotEmpty) {
      json['attachmentUrls'] = attachmentUrls;
    }

    final entityId = relatedEntityId?.trim();
    if (entityId != null && entityId.isNotEmpty) {
      json['relatedEntityId'] = entityId;
    }

    final entityType = relatedEntityType?.trim();
    if (entityType != null && entityType.isNotEmpty) {
      json['relatedEntityType'] = entityType;
    }

    return json;
  }

  @override
  List<Object?> get props => [
        subject,
        description,
        category,
        priority,
        attachmentUrls,
        relatedEntityId,
        relatedEntityType,
      ];
}
