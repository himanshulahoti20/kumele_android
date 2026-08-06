import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/interested_hobbies_event.dart';
import 'package:kuemele/features/profile/presentation/profileset/bloc/interested_hobbies_state.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/user_hobby_preference.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/repositories/hobbies_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';
import 'package:kuemele/shared/services/api_service/aiml/aiml_repo.dart';

export 'interested_hobbies_event.dart';
export 'interested_hobbies_state.dart';

class InterestedHobbiesBloc
    extends Bloc<InterestedHobbiesEvent, InterestedHobbiesState> {
  InterestedHobbiesBloc({required HobbiesRepository hobbiesRepository})
      : _hobbiesRepository = hobbiesRepository,
        super(const InterestedHobbiesState()) {
    on<InterestedHobbiesInit>(_onInit);
    on<InterestedHobbiesInterestToggled>(_onInterestToggled);
    on<InterestedHobbiesSave>(_onSave);
  }

  static const _maxSelections = 5;

  final HobbiesRepository _hobbiesRepository;

  Future<void> _onInit(
    InterestedHobbiesInit event,
    Emitter<InterestedHobbiesState> emit,
  ) async {
    emit(state.copyWith(
      status: InterestedHobbiesStatus.loading,
      interests: const [],
      selectedIds: const [],
      categoryNames: const [],
      errorMessage: null,
      successMessage: null,
    ));

    try {
      final results = await Future.wait([
        _hobbiesRepository.getHobbyInterests(),
        _fetchCurrentUserHobbies(),
        _hobbiesRepository.getHobbyCategoryNames(),
        _fetchRecommendedHobbyKeys(),
      ]);

      final interests = results[0] as List<HobbyInterest>;
      final currentHobbies = results[1] as List<UserHobbyPreference>;
      final categoryNames = results[2] as List<String>;
      final recommendedKeys = results[3] as Set<String>;
      final sortedInterests = _sortRecommendedFirst(
        interests,
        recommendedKeys,
      );

      emit(state.copyWith(
        interests: sortedInterests,
        selectedIds: _preselectedIds(sortedInterests, currentHobbies),
        categoryNames: categoryNames,
        status: InterestedHobbiesStatus.loaded,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: InterestedHobbiesStatus.failure,
        errorMessage: e.error ?? 'Failed to load interests.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InterestedHobbiesStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// The user's saved hobbies; failures here should not block the page,
  /// so they fall back to an empty selection.
  Future<List<UserHobbyPreference>> _fetchCurrentUserHobbies() async {
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) return const [];

    try {
      return await _hobbiesRepository.getUserHobbies(userId: userId);
    } catch (_) {
      return const [];
    }
  }

  Future<Set<String>> _fetchRecommendedHobbyKeys() async {
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) return const <String>{};

    try {
      final recommendations = await AimlRepo.getRecommendedHobbies(
        userId: userId,
      );
      return recommendations
          .map((recommendation) => recommendation.hobby.toLowerCase().trim())
          .where((hobby) => hobby.isNotEmpty)
          .toSet();
    } catch (_) {
      return const <String>{};
    }
  }

  List<HobbyInterest> _sortRecommendedFirst(
    List<HobbyInterest> interests,
    Set<String> recommendedKeys,
  ) {
    if (recommendedKeys.isEmpty) return interests;
    final indexed = interests.asMap().entries.toList();
    indexed.sort((a, b) {
      final aRecommended = _isRecommended(a.value, recommendedKeys) ? 0 : 1;
      final bRecommended = _isRecommended(b.value, recommendedKeys) ? 0 : 1;
      final byRecommendation = aRecommended.compareTo(bRecommended);
      return byRecommendation == 0 ? a.key.compareTo(b.key) : byRecommendation;
    });
    return indexed.map((entry) => entry.value).toList();
  }

  bool _isRecommended(HobbyInterest interest, Set<String> recommendedKeys) {
    return recommendedKeys.contains(interest.name.toLowerCase().trim()) ||
        recommendedKeys.contains(interest.slug.toLowerCase().trim());
  }

  /// Preselects saved hobbies that still exist in the available list,
  /// primary hobby first (save marks the first selected id as primary).
  List<String> _preselectedIds(
    List<HobbyInterest> interests,
    List<UserHobbyPreference> currentHobbies,
  ) {
    final availableIds = interests.map((interest) => interest.id).toSet();

    final sorted = List<UserHobbyPreference>.from(currentHobbies)
      ..sort((a, b) => (b.isPrimary ? 1 : 0) - (a.isPrimary ? 1 : 0));

    return sorted
        .map((preference) => preference.hobbyId)
        .where(availableIds.contains)
        .take(_maxSelections)
        .toList();
  }

  void _onInterestToggled(
    InterestedHobbiesInterestToggled event,
    Emitter<InterestedHobbiesState> emit,
  ) {
    if (state.isFetching) return;

    final selectedIds = List<String>.from(state.selectedIds);

    if (selectedIds.contains(event.hobbyId)) {
      selectedIds.remove(event.hobbyId);
    } else if (selectedIds.length < _maxSelections) {
      selectedIds.add(event.hobbyId);
    }

    emit(state.copyWith(selectedIds: selectedIds));
  }

  Future<void> _onSave(
    InterestedHobbiesSave event,
    Emitter<InterestedHobbiesState> emit,
  ) async {
    if (state.selectedIds.isEmpty) return;

    emit(state.copyWith(
      status: InterestedHobbiesStatus.saving,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      final userId = InjectionHelper.profileCubit.userData?.id;
      if (userId == null || userId.isEmpty) {
        throw ApiException(error: 'User profile is not available.');
      }

      final successMessage = await _hobbiesRepository.updateUserHobbies(
        userId: userId,
        hobbies: UserHobbyPreference.fromSelectedHobbyIds(state.selectedIds),
      );

      emit(state.copyWith(
        status: InterestedHobbiesStatus.success,
        successMessage: successMessage,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: InterestedHobbiesStatus.loaded,
        errorMessage: e.error ?? 'Failed to save interests.',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: InterestedHobbiesStatus.loaded,
        errorMessage: e.toString(),
      ));
    }
  }
}
