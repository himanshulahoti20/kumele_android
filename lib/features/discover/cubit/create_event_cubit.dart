import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/cubit/create_event_state.dart';
import 'package:kuemele/features/discover/data/models/create_event_request_model.dart';
import 'package:kuemele/features/discover/domain/repositories/create_event_repository.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_models.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/models/event_category.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';
import 'package:kuemele/shared/utils/utils.dart';

export 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit({
    required ImagePickerService imagePickerService,
    required CreateEventRepository repository,
  })  : _imagePickerService = imagePickerService,
        _repository = repository,
        super(CreateEventState.empty);

  final ImagePickerService _imagePickerService;
  final CreateEventRepository _repository;

  Future<void> initializeForm() async {
    safeEmit(
      CreateEventState.empty.copyWith(
        status: CreateEventStatus.loading,
        clearError: true,
      ),
    );

    try {
      final categories = await ProfileRepo.getEventCategories();
      InjectionHelper.profileCubit.eventCategories = categories;

      safeEmit(
        state.copyWith(
          status: CreateEventStatus.loaded,
          interests: _mapCategoriesToInterests(categories),
        ),
      );
    } on ApiException catch (e) {
      safeEmit(
        state.copyWith(
          status: CreateEventStatus.error,
          error: e.error ?? ApiErrorMessage.APP_BLOC_ERROR,
        ),
      );
    } on Exception {
      safeEmit(
        state.copyWith(
          status: CreateEventStatus.error,
          error: ApiErrorMessage.APP_UNKNOWN_ERROR,
        ),
      );
    }
  }

  void resetForm() => unawaited(initializeForm());

  void updateTitle(String value) {
    safeEmit(state.copyWith(title: value));
  }

  void updateSubtitle(String value) {
    safeEmit(state.copyWith(subtitle: value));
  }

  void updateDescription(String value) {
    safeEmit(state.copyWith(description: value));
  }

  void updateLocation(EventLocation location) {
    safeEmit(state.copyWith(selectedLocation: location));
  }

  void clearLocation() {
    safeEmit(state.copyWith(clearLocation: true));
  }

  void selectInterest(int index) {
    final interests = [
      for (var i = 0; i < state.interests.length; i++)
        state.interests[i].copyWith(isSelected: i == index),
    ];
    safeEmit(state.copyWith(interests: interests));
  }

  void decreaseStartsIn() {
    final next = switch (state.startsIn) {
      EventTimeType.hours_24 => EventTimeType.hours_24,
      EventTimeType.hours_48 => EventTimeType.hours_24,
      EventTimeType.days_7 => EventTimeType.hours_48,
    };
    safeEmit(state.copyWith(startsIn: next));
  }

  void increaseStartsIn() {
    final next = switch (state.startsIn) {
      EventTimeType.hours_24 => EventTimeType.hours_48,
      EventTimeType.hours_48 => EventTimeType.days_7,
      EventTimeType.days_7 => EventTimeType.days_7,
    };
    safeEmit(state.copyWith(startsIn: next));
  }

  void updateDate(DateTime value) {
    safeEmit(
      state.copyWith(
        selectedDate: value,
        date: DateFormat('dd MMM yyyy').format(value),
      ),
    );
  }

  void updateStartTime(TimeOfDay time) {
    safeEmit(
      state.copyWith(
        selectedStartTime: time,
        eventStartTime: _formatTime(time),
      ),
    );
  }

  void updateEndTime(TimeOfDay time) {
    safeEmit(
      state.copyWith(
        selectedEndTime: time,
        eventEndTime: _formatTime(time),
      ),
    );
  }

  void updateGuestPaymentType(String value) {
    safeEmit(state.copyWith(guestPaymentType: value));
  }

  static const int minGuests = 2;
  static const int maxGuests = 150;

  void updateNumberOfGuests(int value) {
    final clamped = value.clamp(minGuests, maxGuests);
    safeEmit(state.copyWith(numberOfGuests: clamped));
  }

  void markPaid() {
    safeEmit(
      state.copyWith(
        hasPay: true,
        status: CreateEventStatus.loaded,
      ),
    );
  }

  void clearEventImage() {
    safeEmit(state.copyWith(clearEventImage: true));
  }

  Future<void> pickEventImage(ImagePickerSource source) async {
    if (!_imagePickerService.isSupported) {
      InjectionHelper.snackBar.showError(
        'Image upload is only available on Android.',
      );
      return;
    }

    safeEmit(state.copyWith(isPickingEventImage: true, clearError: true));

    try {
      final image = await _imagePickerService.pickImage(source);
      if (image != null) {
        safeEmit(
          state.copyWith(
            isPickingEventImage: false,
            eventImagePath: image.path,
          ),
        );
      } else {
        safeEmit(state.copyWith(isPickingEventImage: false));
      }
    } on ImagePickerPermissionPermanentlyDeniedException catch (e) {
      safeEmit(state.copyWith(isPickingEventImage: false));
      InjectionHelper.snackBar.showError(e.message);
    } on ImagePickerPermissionDeniedException catch (e) {
      safeEmit(state.copyWith(isPickingEventImage: false));
      InjectionHelper.snackBar.showError(e.message);
    } on AppImagePickerException catch (e) {
      safeEmit(state.copyWith(isPickingEventImage: false));
      InjectionHelper.snackBar.showError(e.message);
    } on Exception {
      safeEmit(state.copyWith(isPickingEventImage: false));
      InjectionHelper.snackBar.showError('Failed to pick image.');
    }
  }

  Future<void> submitEvent() async {
    if (!validateForm()) return;

    safeEmit(
        state.copyWith(status: CreateEventStatus.submitting, clearError: true));

    try {
      String? coverImage;
      final imagePath = state.eventImagePath;
      if (imagePath != null && imagePath.isNotEmpty) {
        final upload = await _repository.uploadEventBanner(imagePath);
        coverImage = upload.url;
      }

      final selectedCategory =
          state.interests.firstWhere((interest) => interest.isSelected);

      final request = CreateEventRequestModel(
        title: state.title.trim(),
        description: state.description.trim(),
        hobbyCategoryId: selectedCategory.id!,
        eventStartTime:
            _toUtcIso(state.selectedDate!, state.selectedStartTime!),
        eventEndTime: _toUtcIso(state.selectedDate!, state.selectedEndTime!),
        capacity: state.numberOfGuests,
        isPaid: state.isPaidEvent,
        basePriceEur: 0,
        latitude: state.selectedLocation?.latitude ?? 0,
        longitude: state.selectedLocation?.longitude ?? 0,
        displayAddress: state.selectedLocation?.displayAddress ?? '',
        coverImage: coverImage,
      );

      await _repository.createEvent(request);

      safeEmit(state.copyWith(status: CreateEventStatus.success));
      InjectionHelper.snackBar.showSuccess('Event created successfully.');
      resetForm();
    } on ApiException catch (e) {
      final message = e.error ?? ApiErrorMessage.APP_BLOC_ERROR;
      safeEmit(state.copyWith(status: CreateEventStatus.error, error: message));
      InjectionHelper.snackBar.showError(message);
    } on Exception {
      final message = ApiErrorMessage.APP_UNKNOWN_ERROR;
      safeEmit(state.copyWith(status: CreateEventStatus.error, error: message));
      InjectionHelper.snackBar.showError(message);
    }
  }

  bool validateForm() {
    final validationError = _validate();
    if (validationError != null) {
      safeEmit(state.copyWith(error: validationError));
      InjectionHelper.snackBar.showError(validationError);
      return false;
    }

    safeEmit(state.copyWith(clearError: true));
    return true;
  }

  String? _validate() {
    if (state.title.trim().isEmpty) return 'Please enter an event title.';
    if (state.description.trim().isEmpty) {
      return 'Please enter an event description.';
    }
    if (!state.interests.any((interest) => interest.isSelected)) {
      return 'Please select an event category.';
    }
    if (state.selectedDate == null) return 'Please select an event date.';
    if (state.selectedStartTime == null) return 'Please select a start time.';
    if (state.selectedEndTime == null) return 'Please select an end time.';
    if (state.selectedLocation == null) {
      return 'Please pick an event location on the map.';
    }
    if (state.eventImagePath == null || state.eventImagePath!.trim().isEmpty) {
      return 'Please select an event image.';
    }
    return null;
  }

  String _toUtcIso(DateTime date, TimeOfDay time) {
    final local = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return local.toUtc().toIso8601String();
  }

  List<InterestsModel> _mapCategoriesToInterests(
    List<EventCategory> categories,
  ) {
    return categories
        .map(
          (category) => InterestsModel(
            id: category.id,
            svgCode: category.svgCode ?? '',
            title: category.name?.capitalize() ?? '',
            isSelected: false,
          ),
        )
        .toList();
  }

  String _formatTime(TimeOfDay time) {
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00 $period';
  }
}
