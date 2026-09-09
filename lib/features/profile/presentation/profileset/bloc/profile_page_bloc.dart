import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/auth/domain/repositories/auth_repository.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connections_page.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/repositories/connections_repository.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_event.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/profile_page_state.dart';
import 'package:kuemele/features/profile/presentation/security/security_config.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/models/history_statistics_models.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/statistics/statistics_repo.dart';

export 'profile_page_event.dart';
export 'profile_page_state.dart';

class ProfilePageBloc extends Bloc<ProfilePageEvent, ProfilePageState> {
  ProfilePageBloc({
    required ProfileCubit profileCubit,
    required AuthRepository authRepository,
    required ConnectionsRepository connectionsRepository,
  })  : _profileCubit = profileCubit,
        _authRepository = authRepository,
        _connectionsRepository = connectionsRepository,
        super(const ProfilePageState()) {
    on<ProfilePageInit>(_onInit);
    on<ProfilePageRefresh>(_onRefresh);
    on<ProfilePageThemeToggled>(_onThemeToggled);
    on<ProfilePagePasskeyRegisterRequested>(_onPasskeyRegisterRequested);
    on<ProfilePageFeedbackCleared>(_onFeedbackCleared);
  }

  final ProfileCubit _profileCubit;
  final AuthRepository _authRepository;
  final ConnectionsRepository _connectionsRepository;

  Future<void> _onInit(
    ProfilePageInit event,
    Emitter<ProfilePageState> emit,
  ) async {
    emit(_buildState());
    await _refreshProfileStats(emit);
  }

  Future<void> _onRefresh(
    ProfilePageRefresh event,
    Emitter<ProfilePageState> emit,
  ) async {
    // Deliberately doesn't call _profileCubit.loadUserData() here: that
    // emits a new ProfileCubit state, which Profile's BlocConsumer listener
    // reacts to by dispatching ProfilePageRefresh again — an infinite
    // refresh loop. The tab-entry refetch lives in Profile.initState()
    // instead, as a single direct call.
    emit(_buildState());
    await _refreshProfileStats(emit);
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
          successMessage: AppLocalizationsEn().passkeyRegisterSuccess,
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
    int? followingCount,
    int? followersCount,
    String? goldStatus,
    String? topMedalTier,
    String? topMedalCount,
    bool? isPasskeyRegistering,
    String? successMessage,
    String? errorMessage,
    bool clearSuccessMessage = false,
    bool clearErrorMessage = false,
  }) {
    return ProfilePageState(
      profileStatus: profileStatus ?? _profileCubit.state.status,
      userData: _profileCubit.userData,
      qrCodeInfo: _profileCubit.qrCodeInfo,
      primarySettings: ProfileConfig.primarySettings(),
      secondarySettings: ProfileConfig.secondarySettings(),
      securitySettings: SecurityConfig.settings(),
      followingCount: followingCount ?? state.followingCount,
      followersCount: followersCount ?? state.followersCount,
      goldStatus: goldStatus ?? state.goldStatus,
      topMedalTier: topMedalTier ?? state.topMedalTier,
      topMedalCount: topMedalCount ?? state.topMedalCount,
      isDarkMode: _profileCubit.isDark,
      isPasskeyRegistering: isPasskeyRegistering ?? state.isPasskeyRegistering,
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? state.successMessage),
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? state.errorMessage),
    );
  }

  Future<void> _refreshProfileStats(Emitter<ProfilePageState> emit) async {
    final userId = _profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) return;

    try {
      final results = await Future.wait([
        _connectionsRepository.getFollowing(userId: userId, limit: 1),
        _connectionsRepository.getFollowers(userId: userId, limit: 1),
        StatisticsRepo.getRewardStatus(userId),
      ]);
      final following = results[0] as FollowConnectionsPage;
      final followers = results[1] as FollowConnectionsPage;
      final rewards = results[2] as RewardStatus?;
      final topMedal = _highestMedal(rewards);

      emit(
        _buildState(
          followingCount: following.total,
          followersCount: followers.total,
          goldStatus: (rewards?.gold ?? 0).toString(),
          topMedalTier: topMedal.$1,
          topMedalCount: topMedal.$2.toString(),
        ),
      );
    } catch (_) {}
  }

  /// Highest tier actually held (gold beats silver beats bronze) — never
  /// the sum of all three.
  static (String, int) _highestMedal(RewardStatus? rewards) {
    if (rewards == null) return ('Gold', 0);
    if (rewards.gold > 0) return ('Gold', rewards.gold);
    if (rewards.silver > 0) return ('Silver', rewards.silver);
    if (rewards.bronze > 0) return ('Bronze', rewards.bronze);
    return ('Gold', 0);
  }
}
