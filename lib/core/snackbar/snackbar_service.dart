import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/core/snackbar/snackbar_type.dart';
import 'package:kuemele/l10n/app_localizations.dart';
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

  /// Neutral/success/error/warning/info messages are shown as a blocking
  /// popup alert (not a toast) so they can't be missed or scroll past unread.
  void showNeutral(String message) => _showAlert(message, SnackBarType.neutral);

  void showSuccess(String message) => _showAlert(message, SnackBarType.success);

  void showError(String message) => _showAlert(message, SnackBarType.error);

  void showWarning(String message) => _showAlert(message, SnackBarType.warning);

  void showInfo(String message) => _showAlert(message, SnackBarType.info);

  void _showAlert(String message, SnackBarType type) {
    SmartDialog.show(
      clickMaskDismiss: true,
      builder: (_) => _AlertPopupDialog(message: message, type: type),
    );
  }

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

class _AlertPopupDialog extends StatelessWidget {
  const _AlertPopupDialog({required this.message, required this.type});

  final String message;
  final SnackBarType type;

  @override
  Widget build(BuildContext context) {
    final isSuccess = type == SnackBarType.success || type == SnackBarType.info;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 96,
                height: 96,
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
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: SmartDialog.dismiss,
                  child: Text(AppLocalizations.of(context)?.ok ?? 'OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, -4),
                      color: Colors.black26,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 20),
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
          ),
        ),
      ),
    );
  }
}
