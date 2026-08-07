import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';
import 'package:kuemele/features/profile/cubit/profile_cubit.dart';
import 'package:kuemele/features/profile/presentation/my_events/cubit/my_events_state.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
import 'package:kuemele/shared/bloc/bloc_extension.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

class MyEventsCubit extends Cubit<MyEventsState> {
  MyEventsCubit({
    required ExploreRepository repository,
    required ProfileCubit profileCubit,
  })  : _repository = repository,
        _profileCubit = profileCubit,
        super(const MyEventsState());

  final ExploreRepository _repository;
  final ProfileCubit _profileCubit;

  void selectTab(MyEventsTab tab) {
    if (state.activeTab == tab) return;
    safeEmit(state.copyWith(activeTab: tab));
  }

  Future<void> loadCreatedEvents({int limit = 20}) async {
    final hostId = _profileCubit.userData?.id?.trim() ?? '';
    if (hostId.isEmpty) {
      safeEmit(
        state.copyWith(
          status: MyEventsStatus.failure,
          errorMessage: AppLocalizationsEn().somethingWentWrong,
        ),
      );
      return;
    }

    safeEmit(
      state.copyWith(
        status: MyEventsStatus.loading,
        clearError: true,
      ),
    );

    try {
      final page = await _repository.getEventsByHostId(hostId, limit: limit);

      safeEmit(
        state.copyWith(
          status: MyEventsStatus.loaded,
          createdEvents: page.events,
        ),
      );
    } on ApiException catch (e) {
      safeEmit(
        state.copyWith(
          status: MyEventsStatus.failure,
          errorMessage: e.error ?? AppLocalizationsEn().somethingWentWrong,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: MyEventsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
