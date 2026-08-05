import 'package:flutter_bloc/flutter_bloc.dart';

class VisibleByPageState {
  const VisibleByPageState._({required this.isVisible});

  final bool isVisible;

  static const show = VisibleByPageState._(isVisible: true);
  static const hide = VisibleByPageState._(isVisible: false);
}

class VisibleByPageCubit extends Cubit<VisibleByPageState> {
  VisibleByPageCubit({
    required this.screenToShow,
    required this.screenNotShow,
  }) : super(VisibleByPageState.hide);

  final List<String> screenNotShow;
  final List<String> screenToShow;

  void onScreenChange(String? currentScreen) {
    if (screenNotShow.isNotEmpty) {
      if (currentScreen == null ||
          screenNotShow
              .where((element) => element.contains(currentScreen))
              .isNotEmpty) {
        emit(VisibleByPageState.hide);
      } else {
        emit(VisibleByPageState.show);
      }
    }
    if (screenToShow.isNotEmpty) {
      if (currentScreen == null || screenToShow.contains(currentScreen)) {
        emit(VisibleByPageState.show);
      } else {
        emit(VisibleByPageState.hide);
      }
    }
  }
}
