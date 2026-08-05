import 'package:kuemele/shared/services/pagination/pagination_state.dart';
import 'package:kuemele/shared/services/api_service/api_exception.dart';

class PaginationService<T> {
  const PaginationService({
    required this.fetchPage,
    this.defaultLimit = 20,
  });

  final Future<PaginatedResult<T>> Function({
    required int page,
    required int limit,
  }) fetchPage;

  final int defaultLimit;

  Future<void> loadInitial({
    required void Function(PaginationState<T>) emit,
    required PaginationState<T> currentState,
    bool refresh = false,
  }) async {
    final isRefresh = refresh && currentState.items.isNotEmpty;

    if (isRefresh) {
      emit(currentState.copyWith(isRefreshing: true, clearError: true));
    } else {
      if (currentState.status == PaginationStatus.loading) return;
      emit(
        currentState.copyWith(
          status: PaginationStatus.loading,
          clearError: true,
        ),
      );
    }

    await _fetchPage(
      emit,
      currentState: currentState,
      page: 1,
      append: false,
    );
  }

  Future<void> loadMore({
    required void Function(PaginationState<T>) emit,
    required PaginationState<T> currentState,
  }) async {
    if (!currentState.hasMore ||
        currentState.isRefreshing ||
        currentState.status == PaginationStatus.loading ||
        currentState.status == PaginationStatus.loadingMore) {
      return;
    }

    emit(currentState.copyWith(status: PaginationStatus.loadingMore));
    await _fetchPage(
      emit,
      currentState: currentState,
      page: currentState.page + 1,
      append: true,
    );
  }

  Future<void> retry({
    required void Function(PaginationState<T>) emit,
    required PaginationState<T> currentState,
  }) async {
    await loadInitial(
      emit: emit,
      currentState: currentState,
      refresh: true,
    );
  }

  Future<void> _fetchPage(
    void Function(PaginationState<T>) emit, {
    required PaginationState<T> currentState,
    required int page,
    required bool append,
  }) async {
    try {
      final result = await fetchPage(page: page, limit: defaultLimit);

      final items = append
          ? [...currentState.items, ...result.items]
          : result.items;

      emit(
        currentState.copyWith(
          status: PaginationStatus.loaded,
          items: items,
          page: result.page,
          hasMore: result.hasMore,
          isRefreshing: false,
          clearError: true,
        ),
      );
    } catch (error) {
      final errorMessage = error is ApiException
          ? (error.error ?? 'Failed to load data.')
          : error.toString();

      final shouldKeepLoaded = append && currentState.items.isNotEmpty;

      emit(
        currentState.copyWith(
          status: shouldKeepLoaded
              ? PaginationStatus.loaded
              : PaginationStatus.failure,
          errorMessage: errorMessage,
          isRefreshing: false,
        ),
      );
    }
  }
}

class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  final List<T> items;
  final int page;
  final bool hasMore;
}
