sealed class SwipeCardEvent {
  const SwipeCardEvent();
}

final class SwipeCardExpandToggled extends SwipeCardEvent {
  const SwipeCardExpandToggled();
}

final class SwipeCardCollapsed extends SwipeCardEvent {
  const SwipeCardCollapsed();
}
