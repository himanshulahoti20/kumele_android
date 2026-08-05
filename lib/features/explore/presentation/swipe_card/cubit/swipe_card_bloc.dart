import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/cubit/swipe_card_event.dart';
import 'package:kuemele/features/explore/presentation/swipe_card/cubit/swipe_card_state.dart';

export 'swipe_card_event.dart';
export 'swipe_card_state.dart';

class SwipeCardBloc extends Bloc<SwipeCardEvent, SwipeCardState> {
  SwipeCardBloc() : super(const SwipeCardState()) {
    on<SwipeCardExpandToggled>(_onExpandToggled);
    on<SwipeCardCollapsed>(_onCollapsed);
  }

  void _onExpandToggled(
    SwipeCardExpandToggled event,
    Emitter<SwipeCardState> emit,
  ) {
    emit(state.copyWith(isExpanded: !state.isExpanded));
  }

  void _onCollapsed(
    SwipeCardCollapsed event,
    Emitter<SwipeCardState> emit,
  ) {
    if (!state.isExpanded) return;
    emit(state.copyWith(isExpanded: false));
  }
}
