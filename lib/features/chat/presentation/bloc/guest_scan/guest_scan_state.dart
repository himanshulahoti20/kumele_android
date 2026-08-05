part of 'guest_scan_bloc.dart';

enum GuestScanStatus { initial, loading, success, error }

enum GuestCheckInStatus { idle, loading, success, error }

class GuestScanState extends Equatable {
  final GuestScanStatus status;
  final List<EventGuestEntity> guests;
  final String? errorMessage;
  final GuestCheckInStatus checkInStatus;
  final String? checkInErrorMessage;
  final String? checkInSuccessMessage;

  const GuestScanState({
    this.status = GuestScanStatus.initial,
    this.guests = const [],
    this.errorMessage,
    this.checkInStatus = GuestCheckInStatus.idle,
    this.checkInErrorMessage,
    this.checkInSuccessMessage,
  });

  GuestScanState copyWith({
    GuestScanStatus? status,
    List<EventGuestEntity>? guests,
    String? errorMessage,
    GuestCheckInStatus? checkInStatus,
    String? checkInErrorMessage,
    String? checkInSuccessMessage,
    bool clearCheckInMessages = false,
  }) {
    return GuestScanState(
      status: status ?? this.status,
      guests: guests ?? this.guests,
      errorMessage: errorMessage ?? this.errorMessage,
      checkInStatus: checkInStatus ?? this.checkInStatus,
      checkInErrorMessage: clearCheckInMessages
          ? null
          : checkInErrorMessage ?? this.checkInErrorMessage,
      checkInSuccessMessage: clearCheckInMessages
          ? null
          : checkInSuccessMessage ?? this.checkInSuccessMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        guests,
        errorMessage,
        checkInStatus,
        checkInErrorMessage,
        checkInSuccessMessage,
      ];
}
