import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/profile/presentation/connections/bloc/connections_event.dart';
import 'package:kuemele/features/profile/presentation/connections/bloc/connections_state.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/repositories/connections_repository.dart';
import 'package:kuemele/l10n/app_localizations_en.dart';
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
    on<ConnectionsSelectionStarted>(_onSelectionStarted);
    on<ConnectionsSelectionToggled>(_onSelectionToggled);
    on<ConnectionsSelectAllToggled>(_onSelectAllToggled);
    on<ConnectionsSelectionCancelled>(_onSelectionCancelled);
    on<ConnectionsRemoveSelectedConfirmed>(_onRemoveSelectedConfirmed);
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

    emit(state.copyWith(
      selectedTab: event.tab,
      clearErrorMessage: true,
      isSelectionMode: false,
      selectedIds: const {},
    ));

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

  void _onSelectionStarted(
    ConnectionsSelectionStarted event,
    Emitter<ConnectionsState> emit,
  ) {
    emit(state.copyWith(isSelectionMode: true, selectedIds: {event.userId}));
  }

  void _onSelectionToggled(
    ConnectionsSelectionToggled event,
    Emitter<ConnectionsState> emit,
  ) {
    final updated = Set<String>.from(state.selectedIds);
    if (!updated.remove(event.userId)) updated.add(event.userId);
    emit(state.copyWith(selectedIds: updated));
  }

  void _onSelectAllToggled(
    ConnectionsSelectAllToggled event,
    Emitter<ConnectionsState> emit,
  ) {
    if (state.isAllSelected) {
      emit(state.copyWith(selectedIds: const {}));
      return;
    }
    emit(state.copyWith(
      selectedIds: state.activeUsers.map((user) => user.id).toSet(),
    ));
  }

  void _onSelectionCancelled(
    ConnectionsSelectionCancelled event,
    Emitter<ConnectionsState> emit,
  ) {
    emit(state.copyWith(isSelectionMode: false, selectedIds: const {}));
  }

  /// "Remove" only actually unfollows — the backend has no separate
  /// "remove a follower" endpoint, only `POST`/`DELETE /users/{id}/follow`.
  /// On the Followers tab this silently no-ops for anyone not mutually
  /// followed back; that's a backend limitation, not fixable client-side.
  Future<void> _onRemoveSelectedConfirmed(
    ConnectionsRemoveSelectedConfirmed event,
    Emitter<ConnectionsState> emit,
  ) async {
    final ids = state.selectedIds;
    if (ids.isEmpty) return;

    emit(state.copyWith(isSelectionMode: false, selectedIds: const {}));

    var hadFailure = false;
    for (final id in ids) {
      try {
        await _connectionsRepository.unfollow(userId: id);
      } on ApiException catch (e) {
        // 404 "Not following this user": the list was stale; the reload below drops the row.
        if (e.statusCode == 404) {
          InjectionHelper.snackBar.showWarning(e.error ?? '');
        } else {
          hadFailure = true;
        }
      } catch (_) {
        hadFailure = true;
      }
    }

    await _loadTab(emit, state.selectedTab, forceReload: true);
    if (hadFailure) {
      emit(state.copyWith(errorMessage: AppLocalizationsEn().unfollowFailedMessage));
    }
  }

  Future<void> _loadTab(
    Emitter<ConnectionsState> emit,
    ConnectionsTab tab, {
    bool forceReload = false,
  }) async {
    final userId = InjectionHelper.profileCubit.userData?.id;
    if (userId == null || userId.isEmpty) {
      _emitTabFailure(emit, tab, AppLocalizationsEn().connectionsLoadFailed);
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
          error.error ?? AppLocalizationsEn().connectionsLoadFailed,
        );
      } catch (_) {
        _emitTabFailure(emit, tab, AppLocalizationsEn().connectionsLoadFailed);
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
        error.error ?? AppLocalizationsEn().connectionsLoadFailed,
      );
    } catch (_) {
      _emitTabFailure(emit, tab, AppLocalizationsEn().connectionsLoadFailed);
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
        AppLocalizationsEn().following.toLowerCase()) {
      return ConnectionsTab.following;
    }
    return ConnectionsTab.followers;
  }
}
