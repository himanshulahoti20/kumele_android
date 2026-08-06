import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/discover/cubit/create_event_state.dart';
import 'package:kuemele/features/discover/data/models/create_event_request_model.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/discover/domain/repositories/create_event_repository.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_models.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/models/event_category.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/aiml/aiml_repo.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';
import 'package:kuemele/shared/services/api_service/web3/web3_repo.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';
import 'package:kuemele/shared/services/payment/payment_sdk_service.dart';
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
      final eventPlans = await _loadEventPlans();
      InjectionHelper.profileCubit.eventCategories = categories;

      safeEmit(
        state.copyWith(
          status: CreateEventStatus.loaded,
          interests: _mapCategoriesToInterests(categories),
          eventPlans: eventPlans,
        ),
      );
      unawaited(_refreshQuote(state.numberOfGuests));
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
  void updateNumberOfGuests(int value) {
    final clamped = value.clamp(minGuests, state.maximumGuests);
    safeEmit(state.copyWith(numberOfGuests: clamped));
    unawaited(_refreshQuote(clamped));
  }

  Future<List<EventPlanModel>> _loadEventPlans() async {
    try {
      return await _repository.fetchEventPlans();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _refreshQuote(int capacity) async {
    try {
      final quote = await _repository.fetchEventPlanQuote(capacity);
      if (quote == null || isClosed) return;
      safeEmit(state.copyWith(guestQuoteLabel: quote.label));
    } catch (_) {}
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
      if (!await _moderateEventDraft()) return;

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

      final createdEvent = await _repository.createEvent(request);
      if (createdEvent.requiresPayment && createdEvent.eventId.isNotEmpty) {
        await _startCreationPayment(createdEvent.eventId);
      }

      safeEmit(state.copyWith(status: CreateEventStatus.success));
      InjectionHelper.snackBar.showSuccess(createdEvent.requiresPayment
          ? 'Event created. Complete payment to activate it.'
          : 'Event created successfully.');
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

  Future<void> loadAimlEventAdvice() async {
    if (!validateForm()) return;

    final selectedCategory = state.interests.firstWhere(
      (interest) => interest.isSelected,
      orElse: () => InterestsModel(title: '', isSelected: false),
    );
    final location = state.selectedLocation?.displayAddress ?? '';
    final eventId = 'draft-${DateTime.now().millisecondsSinceEpoch}';
    final eventDateTime =
        _toUtcIso(state.selectedDate!, state.selectedStartTime!);

    safeEmit(
      state.copyWith(
        isLoadingAimlAdvice: true,
        clearAimlAdvice: true,
        clearError: true,
      ),
    );

    try {
      final attendance = await AimlRepo.predictAttendance(
        eventId: eventId,
        hobby: selectedCategory.title,
        location: location,
        eventDateTime: eventDateTime,
        isPaid: state.isPaidEvent,
        capacity: state.numberOfGuests,
      );

      final hostId = InjectionHelper.profileCubit.userData?.id;
      final pricing = hostId == null || hostId.isEmpty
          ? null
          : await AimlRepo.optimisePricing(
              eventId: eventId,
              hostId: hostId,
              category: selectedCategory.title,
              location: location,
              capacity: state.numberOfGuests,
              eventDate: DateFormat('yyyy-MM-dd').format(state.selectedDate!),
              basePrice: 0,
            );

      if (isClosed) return;
      safeEmit(
        state.copyWith(
          attendancePrediction: attendance,
          pricingAdvice: pricing,
          isLoadingAimlAdvice: false,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      safeEmit(state.copyWith(isLoadingAimlAdvice: false));
    }
  }

  Future<bool> _moderateEventDraft() async {
    try {
      final result = await AimlRepo.moderateText(
        entityType: 'event',
        entityId: 'draft-${DateTime.now().millisecondsSinceEpoch}',
        text: '${state.title.trim()}\n${state.description.trim()}',
      );
      if (isClosed) return false;
      if (!result.needsReview) {
        safeEmit(state.copyWith(moderationResult: result));
        return true;
      }

      final message = result.labels.isEmpty
          ? 'Please adjust event title or description before publishing.'
          : 'Please adjust event content: ${result.labels.join(', ')}.';
      safeEmit(
        state.copyWith(
          status: CreateEventStatus.loaded,
          moderationResult: result,
          error: message,
        ),
      );
      InjectionHelper.snackBar.showError(message);
      return false;
    } catch (_) {
      return true;
    }
  }

  Future<void> _startCreationPayment(String eventId) async {
    try {
      final payment = await Web3Repo.createEventCreationPayment(eventId);
      if (!_requiresPayment(payment)) return;
      if (await PaymentSdkService.presentStripePaymentSheet(
        payment,
        primaryButtonLabel: 'Pay now',
      )) {
        final paymentIntentId = _paymentIntentId(payment);
        if (paymentIntentId == null) {
          throw Exception('No Stripe payment intent returned.');
        }
        await Web3Repo.confirmStripePayment(paymentIntentId);
        return;
      }
    } catch (_) {}

    final order = await Web3Repo.createPayPalEventCreationOrder(eventId);
    if (order?.requiresPayment == false) return;
    final orderId = order?.orderId;
    final approvalUrl = order?.approvalUrl;
    final context = InjectionHelper.navKey.currentContext;
    if (context == null ||
        !context.mounted ||
        orderId == null ||
        orderId.isEmpty ||
        approvalUrl == null ||
        approvalUrl.isEmpty) {
      throw Exception('No event payment approval URL returned.');
    }

    if (!await PaymentSdkService.presentPayPalApprovalUrl(
      context: context,
      approvalUrl: approvalUrl,
      orderId: orderId,
    )) {
      throw Exception('PayPal payment was not approved.');
    }

    final capture = await Web3Repo.capturePayPalOrder(orderId);
    final status = capture['status']?.toString().toUpperCase();
    if (status != null && status != 'COMPLETED') {
      throw Exception('PayPal payment was not completed.');
    }
  }

  bool _requiresPayment(Map<String, dynamic> payload) {
    if (payload['requiresPayment'] == false ||
        payload['requires_payment'] == false) {
      return false;
    }
    return payload.isNotEmpty;
  }

  String? _paymentIntentId(Map<String, dynamic> payload) {
    final clientSecret = _stringValue(payload, const [
      'paymentIntentClientSecret',
      'payment_intent_client_secret',
      'clientSecret',
      'client_secret',
    ]);
    final marker = clientSecret?.indexOf('_secret_') ?? -1;
    if (clientSecret != null && marker > 0) {
      return clientSecret.substring(0, marker);
    }
    return _stringValue(payload, const [
      'paymentIntentId',
      'payment_intent_id',
      'paymentIntentID',
    ]);
  }

  String? _stringValue(Map<String, dynamic> payload, List<String> keys) {
    for (final key in keys) {
      final value = payload[key];
      if (value != null) return value.toString();
    }
    for (final value in payload.values) {
      if (value is Map) {
        final nested = _stringValue(Map<String, dynamic>.from(value), keys);
        if (nested != null && nested.isNotEmpty) return nested;
      }
    }
    return null;
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
