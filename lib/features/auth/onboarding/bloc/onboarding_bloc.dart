import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/auth/onboarding/bloc/onboarding_event.dart';
import 'package:kuemele/features/auth/onboarding/bloc/onboarding_state.dart';
import 'package:kuemele/features/auth/onboarding/onboarding_config.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/models/authen_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/profile/profile_repo.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';
import 'package:kuemele/shared/utils/debouncer.dart';

export 'onboarding_event.dart';
export 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required ImagePickerService imagePickerService})
      : _imagePickerService = imagePickerService,
        _usernameDebouncer = Debouncer(),
        super(const OnboardingState()) {
    on<OnboardingReset>(_onReset);
    on<OnboardingPickImage>(_onPickImage);
    on<OnboardingClearImage>(_onClearImage);
    on<OnboardingCheckUsername>(_onCheckUsername);
    on<OnboardingSubmit>(_onSubmit);
  }

  final ImagePickerService _imagePickerService;
  final Debouncer _usernameDebouncer;

  void _onReset(OnboardingReset event, Emitter<OnboardingState> emit) {
    emit(const OnboardingState());
  }

  Future<void> _onPickImage(
    OnboardingPickImage event,
    Emitter<OnboardingState> emit,
  ) async {
    if (!_imagePickerService.isSupported) {
      emit(state.copyWith(
        errorMessage: AppLocalizationsEn().onboardingImagePlatformUnsupported,
      ));
      return;
    }

    emit(state.copyWith(
      status: OnboardingStatus.pickingImage,
      clearError: true,
    ));

    try {
      final image = await _imagePickerService.pickImage(event.source);
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        profileImagePath: image?.path,
        clearProfileImage: image == null,
      ));
    } on ImagePickerPermissionPermanentlyDeniedException catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        errorMessage: e.message,
      ));
    } on ImagePickerPermissionDeniedException catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        errorMessage: e.message,
      ));
    } on AppImagePickerException catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        errorMessage: e.message,
      ));
    } on Exception {
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        errorMessage: AppLocalizationsEn().onboardingImagePickFailed,
      ));
    }
  }

  void _onClearImage(
    OnboardingClearImage event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(clearProfileImage: true, clearError: true));
  }

  Future<void> _onCheckUsername(
    OnboardingCheckUsername event,
    Emitter<OnboardingState> emit,
  ) async {
    final username = event.username.trim();

    if (username.isEmpty) {
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

  Future<void> _onSubmit(
    OnboardingSubmit event,
    Emitter<OnboardingState> emit,
  ) async {
    final about = event.about.trim();
    final username = event.username?.trim();
    final phone = event.phone.trim();

    if (!state.hasProfileImage) {
      emit(state.copyWith(
          errorMessage: AppLocalizationsEn().onboardingImageRequired));
      return;
    }

    if (about.length < OnboardingConfig.aboutMinLength) {
      emit(state.copyWith(
        errorMessage: AppLocalizationsEn().onboardingAboutTooShort,
      ));
      return;
    }

    if (about.length > OnboardingConfig.aboutMaxLength) {
      emit(state.copyWith(
        errorMessage: AppLocalizationsEn().onboardingAboutTooLong,
      ));
      return;
    }

    emit(state.copyWith(
      status: OnboardingStatus.submitting,
      clearError: true,
    ));

    try {
      final avatarUrl = await ProfileRepo.uploadProfileImage(
        state.profileImagePath!,
      );

      final currentUser = InjectionHelper.profileCubit.userData;
      final body = UserModel(
        fullname: currentUser?.fullname,
        username: username?.isNotEmpty == true ? username : null,
        profilePicture: avatarUrl,
        aboutMe: about,
        phone: phone.isNotEmpty ? phone : null,
      );

      await ProfileRepo.updateUserProfile(body: body);
      await InjectionHelper.profileCubit.loadUserData();

      emit(state.copyWith(status: OnboardingStatus.success));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        errorMessage: e.error ?? AppLocalizationsEn().onboardingSubmitFailed,
      ));
    } on Exception {
      emit(state.copyWith(
        status: OnboardingStatus.initial,
        errorMessage: AppLocalizationsEn().onboardingSubmitFailed,
      ));
    }
  }
}
