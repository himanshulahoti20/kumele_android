import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_event.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_state.dart';
import 'package:kuemele/features/profile/presentation/security/security_config.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'profile_page_event.dart';
export 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc({
    required ProfileCubit profileCubit,
    required AuthRepository authRepository,
  })  : _profileCubit = profileCubit,
        _authRepository = authRepository,
        super(const ProfilePageState()) {
    on<ProfilePageInit>(_onInit);
    on<ProfilePageRefresh>(_onRefresh);
    on<ProfilePageThemeToggled>(_onThemeToggled);
    on<ProfilePagePasskeyRegisterRequested>(_onPasskeyRegisterRequested);
    on<ProfilePageFeedbackCleared>(_onFeedbackCleared);
  }

  final ProfileCubit _profileCubit;
  final AuthRepository _authRepository;

  void _onInit(ProfilePageInit event, Emitter<ProfilePageState> emit) {
    emit(_buildState());
  }

  void _onRefresh(ProfilePageRefresh event, Emitter<ProfilePageState> emit) {
    emit(_buildState());
  }

  void _onThemeToggled(
    ProfilePageThemeToggled event,
    Emitter<ProfilePageState> emit,
  ) {
    _profileCubit.switchTheme();
    emit(_buildState());
  }

  Future<void> _onPasskeyRegisterRequested(
    ProfilePagePasskeyRegisterRequested event,
    Emitter<ProfilePageState> emit,
  ) async {
    if (state.isPasskeyRegistering) return;

    emit(
      _buildState(
        isPasskeyRegistering: true,
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ),
    );

    try {
      await _authRepository.registerPasskey();
      emit(
        _buildState(
          isPasskeyRegistering: false,
          successMessage: AppStrings.passkeyRegisterSuccess,
        ),
      );
    } catch (error) {
      emit(
        _buildState(
          isPasskeyRegistering: false,
          errorMessage: ExceptionMessages.from(error),
        ),
      );
    }
  }

  void _onFeedbackCleared(
    ProfilePageFeedbackCleared event,
    Emitter<ProfilePageState> emit,
  ) {
    emit(
      state.copyWith(
        clearSuccessMessage: true,
        clearErrorMessage: true,
      ),
    );
  }

  ProfilePageState _buildState({
    ProfileStatus? profileStatus,
    bool? isPasskeyRegistering,
    String? successMessage,
    String? errorMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    final following = ProfileConfig.demoFollowing();
    final followers = ProfileConfig.demoFollowers();

    return ProfilePageState(
      profileStatus: profileStatus ?? _profileCubit.state.status,
      userData: _profileCubit.userData,
      qrCodeInfo: _profileCubit.qrCodeInfo,
      primarySettings: ProfileConfig.primarySettings(),
      secondarySettings: ProfileConfig.secondarySettings(),
      securitySettings: SecurityConfig.settings(),
      followingCount: following.length,
      followersCount: followers.length,
      goldStatus: ProfileConfig.mockGoldStatus,
      isDarkMode: _profileCubit.isDark,
      isPasskeyRegistering: isPasskeyRegistering ?? state.isPasskeyRegistering,
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? state.successMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? state.errorMessage),
    );
  }
}
