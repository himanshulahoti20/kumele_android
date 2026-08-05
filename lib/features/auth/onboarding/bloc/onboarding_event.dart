import 'package:equatable/equatable.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

final class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}

final class OnboardingPickImage extends OnboardingEvent {
  const OnboardingPickImage(this.source);

  final ImagePickerSource source;

  @override
  List<Object?> get props => [source];
}

final class OnboardingClearImage extends OnboardingEvent {
  const OnboardingClearImage();
}

final class OnboardingSubmit extends OnboardingEvent {
  const OnboardingSubmit({
    required this.about,
    this.phone = '',
    this.username,
  });

  final String about;
  final String phone;
  final String? username;

  @override
  List<Object?> get props => [about, phone, username];
}

final class OnboardingCheckUsername extends OnboardingEvent {
  const OnboardingCheckUsername(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
}
