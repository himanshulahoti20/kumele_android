import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/profile/presentation/contact/bloc/contact_event.dart';
import 'package:kuemele/features/profile/presentation/contact/bloc/contact_state.dart';
import 'package:kuemele/features/profile/presentation/contact/contact_config.dart';
import 'package:kuemele/features/profile/presentation/contact/domain/entities/create_support_ticket_request.dart';
import 'package:kuemele/features/profile/presentation/contact/domain/repositories/contact_support_repository.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';

export 'contact_event.dart';
export 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc({
    required ContactSupportRepository contactSupportRepository,
    required ImagePickerService imagePickerService,
  })  : _contactSupportRepository = contactSupportRepository,
        _imagePickerService = imagePickerService,
        super(const ContactState()) {
    on<ContactOpened>(_onOpened);
    on<ContactSubjectChanged>(_onSubjectChanged);
    on<ContactReasonChanged>(_onReasonChanged);
    on<ContactDescriptionChanged>(_onDescriptionChanged);
    on<ContactCategoryChanged>(_onCategoryChanged);
    on<ContactPriorityChanged>(_onPriorityChanged);
    on<ContactAttachmentSourceSelected>(_onAttachmentSourceSelected);
    on<ContactAttachmentCleared>(_onAttachmentCleared);
    on<ContactSubmitted>(_onSubmitted);
  }

  final ContactSupportRepository _contactSupportRepository;
  final ImagePickerService _imagePickerService;

  void _onOpened(
    ContactOpened event,
    Emitter<ContactState> emit,
  ) {
    emit(
      ContactState(
        subject: ContactReason.business.label,
        reason: ContactReason.business,
        relatedEntityId: event.relatedEntityId,
        relatedEntityType: event.relatedEntityType,
      ),
    );
  }

  void _onSubjectChanged(
    ContactSubjectChanged event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(subject: event.value, clearError: true));
  }

  void _onReasonChanged(
    ContactReasonChanged event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(
      reason: event.reason,
      subject: event.reason.label,
      category: event.reason.category,
      clearError: true,
    ));
  }

  void _onDescriptionChanged(
    ContactDescriptionChanged event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(description: event.value, clearError: true));
  }

  void _onCategoryChanged(
    ContactCategoryChanged event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(category: event.category, clearError: true));
  }

  void _onPriorityChanged(
    ContactPriorityChanged event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(priority: event.priority, clearError: true));
  }

  Future<void> _onAttachmentSourceSelected(
    ContactAttachmentSourceSelected event,
    Emitter<ContactState> emit,
  ) async {
    try {
      final image = await _imagePickerService.pickImage(event.source);
      if (image == null) return;

      emit(
        state.copyWith(
          attachmentPath: image.path,
          clearError: true,
        ),
      );
    } on AppImagePickerException catch (error) {
      emit(state.copyWith(errorMessage: error.message));
    } on Exception {
      emit(state.copyWith(
          errorMessage: AppLocalizationsEn().contactAttachmentPickFailed));
    }
  }

  void _onAttachmentCleared(
    ContactAttachmentCleared event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(clearAttachment: true, clearError: true));
  }

  Future<void> _onSubmitted(
    ContactSubmitted event,
    Emitter<ContactState> emit,
  ) async {
    final subject = state.subject.trim();
    final description = state.description.trim();

    if (subject.isEmpty) {
      emit(state.copyWith(
          errorMessage: AppLocalizationsEn().contactSubjectRequired));
      return;
    }

    if (description.isEmpty) {
      emit(state.copyWith(
          errorMessage: AppLocalizationsEn().contactDescriptionRequired));
      return;
    }

    if (description.length < 20) {
      emit(state.copyWith(
          errorMessage: AppLocalizationsEn().contactDescriptionTooShort));
      return;
    }

    emit(
      state.copyWith(
        status: ContactStatus.submitting,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      final attachmentUrls = <String>[];
      final attachmentPath = state.attachmentPath;
      if (attachmentPath != null && attachmentPath.isNotEmpty) {
        attachmentUrls.add(
          await _contactSupportRepository.uploadAttachment(attachmentPath),
        );
      }

      final message = await _contactSupportRepository.createTicket(
        CreateSupportTicketRequest(
          subject: subject,
          description: description,
          category: state.category,
          priority: state.priority,
          attachmentUrls: attachmentUrls,
          relatedEntityId: state.relatedEntityId,
          relatedEntityType: state.relatedEntityType,
        ),
      );

      emit(
        state.copyWith(
          status: ContactStatus.success,
          successMessage: message ?? AppLocalizationsEn().contactSuccessMessage,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ContactStatus.initial,
          errorMessage: error.error ?? AppLocalizationsEn().contactSubmitFailed,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: ContactStatus.initial,
          errorMessage: AppLocalizationsEn().contactSubmitFailed,
        ),
      );
    }
  }
}
