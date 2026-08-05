import 'package:equatable/equatable.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_config.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';

sealed class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

final class ContactOpened extends ContactEvent {
  const ContactOpened({
    this.relatedEntityId,
    this.relatedEntityType,
  });

  final String? relatedEntityId;
  final String? relatedEntityType;

  @override
  List<Object?> get props => [relatedEntityId, relatedEntityType];
}

final class ContactSubjectChanged extends ContactEvent {
  const ContactSubjectChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ContactDescriptionChanged extends ContactEvent {
  const ContactDescriptionChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class ContactCategoryChanged extends ContactEvent {
  const ContactCategoryChanged(this.category);

  final SupportTicketCategory category;

  @override
  List<Object?> get props => [category];
}

final class ContactPriorityChanged extends ContactEvent {
  const ContactPriorityChanged(this.priority);

  final SupportTicketPriority priority;

  @override
  List<Object?> get props => [priority];
}

final class ContactAttachmentSourceSelected extends ContactEvent {
  const ContactAttachmentSourceSelected(this.source);

  final ImagePickerSource source;

  @override
  List<Object?> get props => [source];
}

final class ContactAttachmentCleared extends ContactEvent {
  const ContactAttachmentCleared();
}

final class ContactSubmitted extends ContactEvent {
  const ContactSubmitted();
}
