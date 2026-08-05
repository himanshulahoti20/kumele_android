import 'package:equatable/equatable.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';

sealed class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

final class EditProfileInit extends EditProfileEvent {
  const EditProfileInit();
}

final class EditProfilePickImage extends EditProfileEvent {
  const EditProfilePickImage(this.source);

  final ImagePickerSource source;

  @override
  List<Object?> get props => [source];
}

final class EditProfileClearImage extends EditProfileEvent {
  const EditProfileClearImage();
}

final class EditProfileUsernameChanged extends EditProfileEvent {
  const EditProfileUsernameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class EditProfileFirstNameChanged extends EditProfileEvent {
  const EditProfileFirstNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class EditProfileLastNameChanged extends EditProfileEvent {
  const EditProfileLastNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class EditProfileBioChanged extends EditProfileEvent {
  const EditProfileBioChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class EditProfilePhoneChanged extends EditProfileEvent {
  const EditProfilePhoneChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

final class EditProfileCheckUsername extends EditProfileEvent {
  const EditProfileCheckUsername(this.username);

  final String username;

  @override
  List<Object?> get props => [username];
}

final class EditProfileSubmit extends EditProfileEvent {
  const EditProfileSubmit();
}
