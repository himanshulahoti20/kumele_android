import 'package:flutter/material.dart';
import 'package:kuemele/features/discover/data/models/audience_estimate_result.dart';
import 'package:kuemele/features/discover/data/models/event_plan_model.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_models.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/models/aiml_models.dart';

enum CreateEventStatus {
  init,
  loading,
  loaded,
  submitting,
  success,
  error,
}

class CreateEventState {
  const CreateEventState({
    this.status = CreateEventStatus.init,
    this.title = '',
    this.subtitle = '',
    this.description = '',
    this.guestPaymentType = CreateEventState.freePaymentType,
    this.startsIn = EventTimeType.hours_24,
    this.date = '',
    this.selectedDate,
    this.eventStartTime = '',
    this.eventEndTime = '',
    this.selectedStartTime,
    this.selectedEndTime,
    this.interests = const [],
    this.hasPay = false,
    this.eventImagePath,
    this.isPickingEventImage = false,
    this.numberOfGuests = 2,
    this.eventPlans = const [],
    this.guestQuoteLabel,
    this.selectedLocation,
    this.moderationResult,
    this.attendancePrediction,
    this.pricingAdvice,
    this.isLoadingAimlAdvice = false,
    this.paypalConnected = false,
    this.showValidationErrors = false,
    this.error,
    this.monthlyEventLimit,
    this.monthlyEventLimitReached = false,
    this.audienceEstimate,
    this.isLoadingAudienceEstimate = false,
  });

  final CreateEventStatus status;
  final String title;
  final String subtitle;
  final String description;
  final String guestPaymentType;
  final EventTimeType startsIn;
  final String date;
  final DateTime? selectedDate;
  final String eventStartTime;
  final String eventEndTime;
  final TimeOfDay? selectedStartTime;
  final TimeOfDay? selectedEndTime;
  final List<InterestsModel> interests;
  final bool hasPay;
  final String? eventImagePath;
  final bool isPickingEventImage;
  final int numberOfGuests;
  final List<EventPlanModel> eventPlans;
  final String? guestQuoteLabel;
  final EventLocation? selectedLocation;
  final AimlModerationResult? moderationResult;
  final AimlAttendancePrediction? attendancePrediction;
  final AimlPricingAdvice? pricingAdvice;
  final bool isLoadingAimlAdvice;
  final bool paypalConnected;
  final bool showValidationErrors;
  final String? error;
  final int? monthlyEventLimit;
  final bool monthlyEventLimitReached;
  final AudienceEstimateResult? audienceEstimate;
  final bool isLoadingAudienceEstimate;

  static const empty = CreateEventState();

  static const freePaymentType = 'Free';

  bool get isPaidEvent => guestPaymentType != freePaymentType;

  int get maximumGuests {
    final max = eventPlans.fold<int>(0, (value, plan) {
      return plan.maxGuests > value ? plan.maxGuests : value;
    });
    return max == 0 ? 150 : max;
  }

  String get dateLabel => date.isEmpty ? 'Select date' : date;

  String get eventStartTimeLabel =>
      eventStartTime.isEmpty ? 'Select start time' : eventStartTime;

  String get eventEndTimeLabel =>
      eventEndTime.isEmpty ? 'Select end time' : eventEndTime;

  CreateEventState copyWith({
    CreateEventStatus? status,
    String? title,
    String? subtitle,
    String? description,
    String? guestPaymentType,
    EventTimeType? startsIn,
    String? date,
    DateTime? selectedDate,
    String? eventStartTime,
    String? eventEndTime,
    TimeOfDay? selectedStartTime,
    TimeOfDay? selectedEndTime,
    List<InterestsModel>? interests,
    bool? hasPay,
    String? eventImagePath,
    bool? isPickingEventImage,
    int? numberOfGuests,
    List<EventPlanModel>? eventPlans,
    String? guestQuoteLabel,
    EventLocation? selectedLocation,
    AimlModerationResult? moderationResult,
    AimlAttendancePrediction? attendancePrediction,
    AimlPricingAdvice? pricingAdvice,
    bool? isLoadingAimlAdvice,
    bool? paypalConnected,
    bool? showValidationErrors,
    String? error,
    int? monthlyEventLimit,
    bool? monthlyEventLimitReached,
    AudienceEstimateResult? audienceEstimate,
    bool? isLoadingAudienceEstimate,
    bool clearError = false,
    bool clearStartTime = false,
    bool clearEndTime = false,
    bool clearEventImage = false,
    bool clearSelectedDate = false,
    bool clearLocation = false,
    bool clearAimlAdvice = false,
  }) {
    return CreateEventState(
      status: status ?? this.status,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      guestPaymentType: guestPaymentType ?? this.guestPaymentType,
      startsIn: startsIn ?? this.startsIn,
      date: date ?? this.date,
      selectedDate:
          clearSelectedDate ? null : selectedDate ?? this.selectedDate,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventEndTime: eventEndTime ?? this.eventEndTime,
      selectedStartTime:
          clearStartTime ? null : selectedStartTime ?? this.selectedStartTime,
      selectedEndTime:
          clearEndTime ? null : selectedEndTime ?? this.selectedEndTime,
      interests: interests ?? this.interests,
      hasPay: hasPay ?? this.hasPay,
      eventImagePath:
          clearEventImage ? null : eventImagePath ?? this.eventImagePath,
      isPickingEventImage: isPickingEventImage ?? this.isPickingEventImage,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      eventPlans: eventPlans ?? this.eventPlans,
      guestQuoteLabel: guestQuoteLabel ?? this.guestQuoteLabel,
      selectedLocation:
          clearLocation ? null : selectedLocation ?? this.selectedLocation,
      moderationResult:
          clearAimlAdvice ? null : moderationResult ?? this.moderationResult,
      attendancePrediction: clearAimlAdvice
          ? null
          : attendancePrediction ?? this.attendancePrediction,
      pricingAdvice:
          clearAimlAdvice ? null : pricingAdvice ?? this.pricingAdvice,
      isLoadingAimlAdvice: isLoadingAimlAdvice ?? this.isLoadingAimlAdvice,
      paypalConnected: paypalConnected ?? this.paypalConnected,
      showValidationErrors: showValidationErrors ?? this.showValidationErrors,
      error: clearError ? null : error ?? this.error,
      monthlyEventLimit: monthlyEventLimit ?? this.monthlyEventLimit,
      monthlyEventLimitReached:
          monthlyEventLimitReached ?? this.monthlyEventLimitReached,
      audienceEstimate: audienceEstimate ?? this.audienceEstimate,
      isLoadingAudienceEstimate:
          isLoadingAudienceEstimate ?? this.isLoadingAudienceEstimate,
    );
  }
}
