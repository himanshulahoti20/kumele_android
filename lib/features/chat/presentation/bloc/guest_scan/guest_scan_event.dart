part of 'guest_scan_bloc.dart';

sealed class GuestScanEvent extends Equatable {
  const GuestScanEvent();

  @override
  List<Object?> get props => [];
}

class LoadGuests extends GuestScanEvent {
  final String eventId;
  const LoadGuests(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class CheckInGuest extends GuestScanEvent {
  final String eventId;
  final String guestUserId;
  final String displayName;

  const CheckInGuest({
    required this.eventId,
    required this.guestUserId,
    required this.displayName,
  });

  @override
  List<Object?> get props => [eventId, guestUserId, displayName];
}
