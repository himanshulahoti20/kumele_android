import 'package:flutter/material.dart';
import 'package:kuemele/features/discover/presentation/create_event/create_event_models.dart';
import 'package:kuemele/shared/models/event_location.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';

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
    this.selectedLocation,
    this.error,
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
  final EventLocation? selectedLocation;
  final String? error;

  static const empty = CreateEventState();

  static const freePaymentType = 'Free';

  bool get isPaidEvent => guestPaymentType != freePaymentType;

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
    EventLocation? selectedLocation,
    String? error,
    bool clearError = false,
    bool clearStartTime = false,
    bool clearEndTime = false,
    bool clearEventImage = false,
    bool clearSelectedDate = false,
    bool clearLocation = false,
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
      selectedLocation:
          clearLocation ? null : selectedLocation ?? this.selectedLocation,
      error: clearError ? null : error ?? this.error,
    );
  }
}
