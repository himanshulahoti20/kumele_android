import 'package:equatable/equatable.dart';

class EventGuestUserEntity extends Equatable {
  const EventGuestUserEntity({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  String get name {
    final trimmed = displayName.trim();
    if (trimmed.isNotEmpty) return trimmed;

    return [
      firstName,
      lastName,
    ]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(' ');
  }

  @override
  List<Object?> get props => [id, displayName, firstName, lastName, avatarUrl];
}

class EventGuestEntity extends Equatable {
  const EventGuestEntity({
    required this.user,
    required this.status,
    this.joinedAt,
    required this.checkedIn,
  });

  final EventGuestUserEntity user;
  final String status;
  final DateTime? joinedAt;
  final bool checkedIn;

  bool get isConfirmed => status.toUpperCase() == 'CONFIRMED';

  factory EventGuestEntity.placeholder([int index = 0]) {
    return EventGuestEntity(
      user: EventGuestUserEntity(
        id: 'placeholder-$index',
        displayName: 'Guest Name',
      ),
      status: 'CONFIRMED',
      checkedIn: false,
    );
  }

  @override
  List<Object?> get props => [user, status, joinedAt, checkedIn];
}
