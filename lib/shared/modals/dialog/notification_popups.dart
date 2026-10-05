import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:lottie/lottie.dart';

/// "Modal sheet card" chrome shared by [ConfirmActionCard] and [AlertToastCard]
/// — tablet branch of ConfirmActionPopupView.swift / PopUpAlert.swift:
/// cornerRadius 12, shadow radius 10, bgAlertColor, maxWidth min(w-32, 420).
class ModalSheetCard extends StatelessWidget {
  const ModalSheetCard({required this.padding, required this.child});

  final double padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius: BorderRadius.circular(12),
        // SwiftUI .shadow(radius: 10): default black @ 33%, blur ~= radius.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.33),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ConfirmActionPopupView.swift: icon 80, title 22 bold, subtitle 14 light,
/// error 13 red, two 15pt buttons (radius 8, spacing 20), padding 26,
/// VStack spacing 30 / inner 16.
class ConfirmActionCard extends StatelessWidget {
  const ConfirmActionCard({
    super.key,
    required this.title,
    required this.cancelTitle,
    required this.confirmTitle,
    required this.onCancel,
    required this.onConfirm,
    this.subtitle,
    this.errorMessage,
    this.isLoading = false,
  });

  final String title;
  final String? subtitle;
  final String cancelTitle;
  final String confirmTitle;
  final String? errorMessage;
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final textColor = ColorSet.textColor;
    return ModalSheetCard(
      padding: 26,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            IconSet.accountIcon,
            width: 80,
            height: 80,
            color: textColor,
          ),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge.copyWith(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
          if (errorMessage != null) ...[
            const SizedBox(height: 30),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge.copyWith(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 30),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: _button(context, cancelTitle, isLoading ? null : onCancel),
              ),
              Expanded(
                child: _button(
                  context,
                  confirmTitle,
                  isLoading ? null : onConfirm,
                  loading: isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // authBgColor = textColor, authTextColor = its inverse (bg2Color).
  Widget _button(
    BuildContext context,
    String label,
    VoidCallback? onTap, {
    bool loading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // SwiftUI `.padding()` = 16 on every side.
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSet.textColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: loading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ColorSet.bg2Color,
                ),
              )
            : Text(
                label,
                style: context.textTheme.bodyLarge.copyWith(
                  color: ColorSet.bg2Color,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  /// Tablet presentation: flat scrim, centered, width min(w-32, 420).
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String cancelTitle,
    required String confirmTitle,
    String? subtitle,

    /// Return null to dismiss on success, or an error message to keep open.
    required Future<String?> Function() onConfirm,
  }) {
    var loading = false;
    String? error;
    return AppDialog.show<void>(
      context: context,
      width: AppDialogSize.notificationModalWidthFor(context),
      barrierColor: ColorSet.scrimFlat,
      dialog: StatefulBuilder(
        builder: (dialogContext, setState) => ConfirmActionCard(
          title: title,
          subtitle: subtitle,
          cancelTitle: cancelTitle,
          confirmTitle: confirmTitle,
          isLoading: loading,
          errorMessage: error,
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirm: () async {
            setState(() {
              loading = true;
              error = null;
            });
            final result = await onConfirm();
            if (!dialogContext.mounted) return;
            if (result == null) {
              Navigator.of(dialogContext).pop();
            } else {
              setState(() {
                loading = false;
                error = result;
              });
            }
          },
        ),
      ),
    );
  }
}

/// PopUpAlert.swift: Lottie 121, text 24 regular, VStack spacing 26,
/// padding 50, auto-dismisses after 2s.
class AlertToastCard extends StatefulWidget {
  const AlertToastCard({super.key, required this.isSuccess, required this.text});

  final bool isSuccess;
  final String text;

  @override
  State<AlertToastCard> createState() => _AlertToastCardState();

  static Future<void> show(
    BuildContext context, {
    required bool isSuccess,
    required String text,
  }) {
    return AppDialog.show<void>(
      context: context,
      width: AppDialogSize.notificationModalWidthFor(context),
      barrierColor: ColorSet.scrimFlat,
      dialog: AlertToastCard(isSuccess: isSuccess, text: text),
    );
  }
}

class _AlertToastCardState extends State<AlertToastCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalSheetCard(
      padding: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            widget.isSuccess
                ? (ColorSet.isDarkMode
                    ? 'assets/animations/success_dark.json'
                    : 'assets/animations/success_light.json')
                : IconSet.jsonError,
            width: 121,
            height: 121,
          ),
          const SizedBox(height: 26),
          Text(
            widget.text,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge.copyWith(
              color: ColorSet.textColor,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
