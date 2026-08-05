class SwipeCardState {
  const SwipeCardState({
    this.isExpanded = false,
  });

  final bool isExpanded;

  SwipeCardState copyWith({
    bool? isExpanded,
  }) {
    return SwipeCardState(
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
