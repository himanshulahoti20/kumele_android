import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/shared/utils/app_route_observer.dart';
import 'package:kuemele/shared/widgets/visible_by_page/visible_by_page_cubit.dart';

class VisibleByPage extends StatefulWidget {
  final List<String> screenNotShow;
  final List<String> screenToShow;
  final Widget child;

  const VisibleByPage({
    super.key,
    this.screenNotShow = const [],
    this.screenToShow = const [],
    required this.child,
  });

  @override
  State<VisibleByPage> createState() => _VisibleByPageState();
}

class _VisibleByPageState extends State<VisibleByPage> {
  late final VisibleByPageCubit cubit;
  late final StreamSubscription<String> screenSubscription;

  @override
  void initState() {
    cubit = VisibleByPageCubit(
        screenNotShow: widget.screenNotShow, screenToShow: widget.screenToShow);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) async => cubit.onScreenChange(AppRouteObserver.currentScreen));
    screenSubscription =
        AppRouteObserver.screenChangeStreamCtrl.stream.listen((screen) {
      cubit.onScreenChange(screen);
    });
    super.initState();
  }

  @override
  void dispose() {
    screenSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisibleByPageCubit, VisibleByPageState>(
      bloc: cubit,
      builder: (context, state) =>
          state.isVisible ? widget.child : const SizedBox.shrink(),
    );
  }
}
