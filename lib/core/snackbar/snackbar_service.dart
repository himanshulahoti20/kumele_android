import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuemele/core/snackbar/snackbar_type.dart';
import 'package:lottie/lottie.dart';

class SnackBarService {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  OverlayEntry? _currentEntry;
  final GlobalKey<_ToastState> _toastKey = GlobalKey<_ToastState>();

  void show(
    String message, {
    SnackBarType type = SnackBarType.neutral,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry? margin,
  }) {
    final overlay = _resolveOverlay();
    if (overlay == null) {
      if (kDebugMode) {
        developer.log(
          'Skipped toast (no Overlay found): $message',
          name: 'SnackBarService',
        );
      }
      return;
    }

    _dismissCurrent();

    _currentEntry = OverlayEntry(
      builder: (_) => _Toast(
        key: _toastKey,
        message: message,
        type: type,
        duration: duration,
        onDismissed: _dismissCurrent,
      ),
    );

    overlay.insert(_currentEntry!);
  }

  void showNeutral(String message) => show(message);

  void showSuccess(String message) => show(message, type: SnackBarType.success);

  void showError(String message) => show(message, type: SnackBarType.error);

  void showWarning(String message) => show(message, type: SnackBarType.warning);

  void showInfo(String message) => show(message, type: SnackBarType.info);

  void hide() {
    _toastKey.currentState?.dismiss();
  }

  OverlayState? _resolveOverlay() {
    final ctx = messengerKey.currentContext;
    if (ctx != null) {
      final overlay = Overlay.maybeOf(ctx);
      if (overlay != null) return overlay;
    }
    OverlayState? found;
    void visitor(Element el) {
      if (found != null) return;
      if (el.widget is Overlay) {
        found = (el as StatefulElement).state as OverlayState?;
        return;
      }
      el.visitChildren(visitor);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(visitor);
    return found;
  }

  void _dismissCurrent() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _Toast extends StatefulWidget {
  const _Toast({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _ctrl.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) dismiss();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void dismiss() {
    if (!mounted) return;
    _ctrl.reverse().whenComplete(() {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess =
        widget.type == SnackBarType.success || widget.type == SnackBarType.info;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Positioned.fill(
      child: FadeTransition(
        opacity: _opacity,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: isTablet
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.10)
                      : Theme.of(context).colorScheme.surface,
                ),
              ),
              Center(
                child: Container(
                  width: isTablet
                      ? (screenWidth - 32).clamp(0.0, 420.0)
                      : double.infinity,
                  margin: isTablet
                      ? const EdgeInsets.symmetric(horizontal: 16)
                      : EdgeInsets.zero,
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 0),
                    boxShadow: isTablet
                        ? const [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black26,
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 121,
                        height: 121,
                        child: isSuccess
                            ? Lottie.asset(
                                isDark
                                    ? 'assets/animations/success_dark.json'
                                    : 'assets/animations/success_light.json',
                                repeat: false,
                              )
                            : Image.asset(
                                'assets/animations/warningLight.gif',
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
