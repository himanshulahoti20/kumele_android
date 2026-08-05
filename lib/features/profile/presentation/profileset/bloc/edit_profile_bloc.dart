import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/onboarding/onboarding_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/edit_profile_event.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/edit_profile_state.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_bloc.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/edit_profile_repository.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';
import 'package:kuemele/shared/utils/debouncer.dart';

export 'edit_profile_event.dart';
export 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required EditProfileRepository editProfileRepository,
    required ImagePickerService imagePickerService,
  })  : _editProfileRepository = editProfileRepository,
        _imagePickerService = imagePickerService,
        _usernameDebouncer = Debouncer(),
        super(
            EditProfileState.fromUser(InjectionHelper.profileCubit.userData)) {
    on<EditProfileInit>(_onInit);
    on<EditProfilePickImage>(_onPickImage);
    on<EditProfileClearImage>(_onClearImage);
    on<EditProfileUsernameChanged>(_onUsernameChanged);
    on<EditProfileCheckUsername>(_onCheckUsername);
    on<EditProfileFirstNameChanged>(_onFirstNameChanged);
    on<EditProfileLastNameChanged>(_onLastNameChanged);
    on<EditProfileBioChanged>(_onBioChanged);
    on<EditProfilePhoneChanged>(_onPhoneChanged);
    on<EditProfileSubmit>(_onSubmit);
  }

  static const int _aboutMaxLength = OnboardingConfig.aboutMaxLength;

  final EditProfileRepository _editProfileRepository;
  final ImagePickerService _imagePickerService;
  final Debouncer _usernameDebouncer;

  void _onInit(EditProfileInit event, Emitter<EditProfileState> emit) async {
    var user = InjectionHelper.profileCubit.userData;
    if (user == null) {
      await InjectionHelper.profileCubit.loadUserData();
      user = InjectionHelper.profileCubit.userData;
    }
    if (user == null) return;

    emit(EditProfileState.fromUser(user).copyWith(clearError: true));
  }

  Future<void> _onPickImage(
    EditProfilePickImage event,
    Emitter<EditProfileState> emit,
  ) async {
    if (!_imagePickerService.isSupported) {
      emit(
        state.copyWith(
          errorMessage: AppStrings.onboardingImagePlatformUnsupported,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: EditProfileStatus.pickingImage,
        clearError: true,
      ),
    );

    try {
      final image = await _imagePickerService.pickImage(event.source);
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          localImagePath: image?.path,
          clearLocalImage: image == null,
        ),
      );
    } on ImagePickerPermissionPermanentlyDeniedException catch (error) {
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          errorMessage: error.message,
        ),
      );
    } on ImagePickerPermissionDeniedException catch (error) {
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          errorMessage: error.message,
        ),
      );
    } on AppImagePickerException catch (error) {
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          errorMessage: error.message,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          errorMessage: AppStrings.onboardingImagePickFailed,
        ),
      );
    }
  }

  void _onClearImage(
    EditProfileClearImage event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(clearLocalImage: true, clearError: true));
  }

  void _onUsernameChanged(
    EditProfileUsernameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(username: event.value, clearError: true));
  }

  Future<void> _onCheckUsername(
    EditProfileCheckUsername event,
    Emitter<EditProfileState> emit,
  ) async {
    final username = event.username.trim();
    final originalUsername = state.originalUsername.trim();

    if (username.isEmpty) {
      _usernameDebouncer.cancel();
      emit(state.copyWith(
        clearUsernameValidation: true,
        isCheckingUsername: false,
      ));
      return;
    }

    if (username == originalUsername) {
      _usernameDebouncer.cancel();
      emit(state.copyWith(
        clearUsernameValidation: true,
        isCheckingUsername: false,
      ));
      return;
    }

    await _usernameDebouncer.runAsync((isLatest) async {
      if (emit.isDone || !isLatest()) return;

      emit(state.copyWith(
        isCheckingUsername: true,
        clearUsernameValidation: true,
      ));

      try {
        final isAvailable =
            await ProfileRepo.checkUsernameAvailability(username);

        if (emit.isDone || !isLatest()) return;

        emit(state.copyWith(
          isUsernameAvailable: isAvailable ?? false,
          isCheckingUsername: false,
        ));
      } on ApiException {
        if (emit.isDone || !isLatest()) return;

        emit(state.copyWith(
          isUsernameAvailable: false,
          isCheckingUsername: false,
        ));
      }
    });
  }

  @override
  Future<void> close() {
    _usernameDebouncer.dispose();
    return super.close();
  }

  void _onFirstNameChanged(
    EditProfileFirstNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(firstName: event.value, clearError: true));
  }

  void _onLastNameChanged(
    EditProfileLastNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(lastName: event.value, clearError: true));
  }

  void _onBioChanged(
    EditProfileBioChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(bio: event.value, clearError: true));
  }

  void _onPhoneChanged(
    EditProfilePhoneChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(phone: event.value, clearError: true));
  }

  Future<void> _onSubmit(
    EditProfileSubmit event,
    Emitter<EditProfileState> emit,
  ) async {
    final username = state.username.trim();
    final firstName = state.firstName.trim();
    final lastName = state.lastName.trim();
    final bio = state.bio.trim();
    final phone = state.phone.trim();

    if (firstName.isEmpty) {
      emit(state.copyWith(
          errorMessage: AppStrings.editProfileFirstNameRequired));
      return;
    }

    final originalUsername = state.originalUsername.trim();
    if (username.isNotEmpty &&
        username != originalUsername &&
        state.isUsernameAvailable != true) {
      if (state.isCheckingUsername) {
        return;
      }
      emit(state.copyWith(
        errorMessage: state.isUsernameAvailable == false
            ? AppStrings.onboardingUsernameTaken
            : AppStrings.editProfileSubmitFailed,
      ));
      return;
    }

    if (bio.length > _aboutMaxLength) {
      emit(state.copyWith(errorMessage: AppStrings.editProfileAboutTooLong));
      return;
    }

    if (phone.isNotEmpty && phone.length < 6) {
      emit(state.copyWith(errorMessage: AppStrings.editProfilePhoneInvalid));
      return;
    }

    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) {
      emit(state.copyWith(errorMessage: AppStrings.editProfileUserMissing));
      return;
    }

    emit(
      state.copyWith(
        status: EditProfileStatus.submitting,
        clearError: true,
      ),
    );

    try {
      var avatarUrl = state.avatarUrl;
      if (state.hasLocalImage) {
        avatarUrl = await _editProfileRepository.uploadProfileImage(
          state.localImagePath!,
        );
      }

      final currentUser = InjectionHelper.profileCubit.userData;
      final updatedUser = await _editProfileRepository.updateProfile(
        userId: userId,
        body: UserModel(
          username: username.isNotEmpty ? username : currentUser?.username,
          firstName: firstName,
          lastName: lastName.isEmpty ? null : lastName,
          profilePicture: avatarUrl,
          aboutMe: bio.isEmpty ? null : bio,
          phone: phone.isEmpty ? null : phone,
        ),
      );

      final profileCubit = InjectionHelper.profileCubit;
      profileCubit.userData = updatedUser;
      profileCubit.reload();
      InjectionHelper.profilePageBloc.add(const ProfilePageRefresh());

      emit(
        state.copyWith(
          status: EditProfileStatus.success,
          avatarUrl: updatedUser.profilePicture ?? avatarUrl,
          clearLocalImage: true,
        ),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          errorMessage: error.error ?? AppStrings.editProfileSubmitFailed,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: EditProfileStatus.initial,
          errorMessage: AppStrings.editProfileSubmitFailed,
        ),
      );
    }
  }
}
