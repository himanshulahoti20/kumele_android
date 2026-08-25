import 'package:equatable/equatable.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_config.dart';

enum ContactStatus {
  initial,
  submitting,
  success,
}

class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.subject = '',
    this.reason = ContactReason.business,
    this.description = '',
    this.category = SupportTicketCategory.other,
    this.priority = SupportTicketPriority.medium,
    this.attachmentPath,
    this.relatedEntityId,
    this.relatedEntityType,
    this.errorMessage,
    this.successMessage,
  });

  final ContactStatus status;
  final String subject;
  final ContactReason reason;
  final String description;
  final SupportTicketCategory category;
  final SupportTicketPriority priority;
  final String? attachmentPath;
  final String? relatedEntityId;
  final String? relatedEntityType;
  final String? errorMessage;
  final String? successMessage;

  bool get isSubmitting => status == ContactStatus.submitting;

  bool get hasAttachment =>
      attachmentPath != null && attachmentPath!.isNotEmpty;

  ContactState copyWith({
    ContactStatus? status,
    String? subject,
    ContactReason? reason,
    String? description,
    SupportTicketCategory? category,
    SupportTicketPriority? priority,
    String? attachmentPath,
    String? relatedEntityId,
    String? relatedEntityType,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearAttachment = false,
    bool clearSuccessMessage = false,
  }) {
    return ContactState(
      status: status ?? this.status,
      subject: subject ?? this.subject,
      reason: reason ?? this.reason,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      attachmentPath:
          clearAttachment ? null : (attachmentPath ?? this.attachmentPath),
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        subject,
        reason,
        description,
        category,
        priority,
        attachmentPath,
        relatedEntityId,
        relatedEntityType,
        errorMessage,
        successMessage,
      ];
}
