import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuemele/core/snackbar/snackbar_type.dart';

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
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
      reverseDuration: const Duration(milliseconds: 260),
    );

    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _ctrl.forward();

    Future.delayed(widget.duration, () {
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
    final bg = widget.type.backgroundColor;
    final fg = widget.type.foregroundColor;
    final icon = widget.type.icon;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Center(
            child: GestureDetector(
              onTap: dismiss,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 32,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        left: BorderSide(color: fg, width: 4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null) ...[
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: fg.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: fg, size: 18),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Flexible(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                              color: fg,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
