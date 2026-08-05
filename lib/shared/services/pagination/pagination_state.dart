import 'package:equatable/equatable.dart';

enum PaginationStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  failure,
}

class PaginationState<T> extends Equatable {
  const PaginationState({
    this.status = PaginationStatus.initial,
    this.items = const [],
    this.page = 0,
    this.hasMore = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  final PaginationStatus status;
  final List<T> items;
  final int page;
  final bool hasMore;
  final bool isRefreshing;
  final String? errorMessage;

  bool get isLoading =>
      status == PaginationStatus.loading && items.isEmpty;

  bool get isLoadingMore => status == PaginationStatus.loadingMore;

  PaginationState<T> copyWith({
    PaginationStatus? status,
    List<T>? items,
    int? page,
    bool? hasMore,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PaginationState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        page,
        hasMore,
        isRefreshing,
        errorMessage,
      ];
}
