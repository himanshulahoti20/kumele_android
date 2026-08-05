import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/connections/bloc/connections_event.dart';
import 'package:kuemele/features/profile/presentation/connections/bloc/connections_state.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/repositories/connections_repository.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

export 'connections_event.dart';
export 'connections_state.dart';

class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  ConnectionsBloc({required ConnectionsRepository connectionsRepository})
      : _connectionsRepository = connectionsRepository,
        super(const ConnectionsState()) {
    on<ConnectionsInit>(_onInit);
    on<ConnectionsTabChanged>(_onTabChanged);
    on<ConnectionsRetry>(_onRetry);
  }

  final ConnectionsRepository _connectionsRepository;
  static const int _pageLimit = 20;

  Future<void> _onInit(
    ConnectionsInit event,
    Emitter<ConnectionsState> emit,
  ) async {
    final selectedTab = _resolveTab(event.selectedTab);

    emit(
      ConnectionsState(
        selectedTab: selectedTab,
        followersStatus: ConnectionsStatus.loading,
        followingStatus: ConnectionsStatus.loading,
      ),
    );

    await _loadTab(emit, selectedTab);

    final otherTab = selectedTab == ConnectionsTab.followers
        ? ConnectionsTab.following
        : ConnectionsTab.followers;
    await _loadTab(emit, otherTab);
  }

  Future<void> _onTabChanged(
    ConnectionsTabChanged event,
    Emitter<ConnectionsState> emit,
  ) async {
    if (state.selectedTab == event.tab) return;

    emit(state.copyWith(selectedTab: event.tab, clearErrorMessage: true));

    final status = event.tab == ConnectionsTab.followers
        ? state.followersStatus
        : state.followingStatus;

    if (status == ConnectionsStatus.initial ||
        status == ConnectionsStatus.failure) {
      await _loadTab(emit, event.tab);
    }
  }

  Future<void> _onRetry(
    ConnectionsRetry event,
    Emitter<ConnectionsState> emit,
  ) async {
    await _loadTab(emit, state.selectedTab, forceReload: true);
  }

  Future<void> _loadTab(
    Emitter<ConnectionsState> emit,
    ConnectionsTab tab, {
    bool forceReload = false,
  }) async {
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) {
      _emitTabFailure(emit, tab, AppStrings.connectionsLoadFailed);
      return;
    }

    if (tab == ConnectionsTab.followers) {
      if (!forceReload && state.followersStatus == ConnectionsStatus.loaded) {
        return;
      }

      emit(
        state.copyWith(
          followersStatus: ConnectionsStatus.loading,
          followers: forceReload ? const [] : state.followers,
          clearErrorMessage: true,
        ),
      );

      try {
        final page = await _connectionsRepository.getFollowers(
          userId: userId,
          page: 1,
          limit: _pageLimit,
        );

        emit(
          state.copyWith(
            followersStatus: ConnectionsStatus.loaded,
            followers: page.users,
            followersTotal: page.total,
          ),
        );
      } on ApiException catch (error) {
        _emitTabFailure(
          emit,
          tab,
          error.error ?? AppStrings.connectionsLoadFailed,
        );
      } catch (_) {
        _emitTabFailure(emit, tab, AppStrings.connectionsLoadFailed);
      }
      return;
    }

    if (!forceReload && state.followingStatus == ConnectionsStatus.loaded) {
      return;
    }

    emit(
      state.copyWith(
        followingStatus: ConnectionsStatus.loading,
        following: forceReload ? const [] : state.following,
        clearErrorMessage: true,
      ),
    );

    try {
      final page = await _connectionsRepository.getFollowing(
        userId: userId,
        page: 1,
        limit: _pageLimit,
      );

      emit(
        state.copyWith(
          followingStatus: ConnectionsStatus.loaded,
          following: page.users,
          followingTotal: page.total,
        ),
      );
    } on ApiException catch (error) {
      _emitTabFailure(
        emit,
        tab,
        error.error ?? AppStrings.connectionsLoadFailed,
      );
    } catch (_) {
      _emitTabFailure(emit, tab, AppStrings.connectionsLoadFailed);
    }
  }

  void _emitTabFailure(
    Emitter<ConnectionsState> emit,
    ConnectionsTab tab,
    String message,
  ) {
    emit(
      state.copyWith(
        followersStatus: tab == ConnectionsTab.followers
            ? ConnectionsStatus.failure
            : state.followersStatus,
        followingStatus: tab == ConnectionsTab.following
            ? ConnectionsStatus.failure
            : state.followingStatus,
        errorMessage: message,
      ),
    );
  }

  ConnectionsTab _resolveTab(String? selectedTab) {
    if (selectedTab?.trim().toLowerCase() ==
        AppStrings.following.toLowerCase()) {
      return ConnectionsTab.following;
    }
    return ConnectionsTab.followers;
  }
}
