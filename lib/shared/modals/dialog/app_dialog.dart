import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog_layout.dart';
import 'package:kuemele/shared/models/web3_models.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/widgets/store_credit_toggle.dart';
import 'package:kuemele/l10n/app_localizations.dart';

export 'app_dialog_layout.dart';

class _AppConfirmDialogHost extends StatefulWidget {
  const _AppConfirmDialogHost({
    required this.title,
    this.confirmText,
    this.cancelText,
    this.content,
    this.onConfirm,
    this.onConfirmAsync,
    this.popOnConfirm = true,
    this.svgIcon,
    this.sheetMode = false,
  });

  final String title;
  final String? confirmText;
  final String? cancelText;
  final Widget? content;
  final VoidCallback? onConfirm;
  final Future<void> Function()? onConfirmAsync;
  final bool popOnConfirm;
  final String? svgIcon;
  final bool sheetMode;

  @override
  State<_AppConfirmDialogHost> createState() => _AppConfirmDialogHostState();
}

class _AppConfirmDialogHostState extends State<_AppConfirmDialogHost> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    if (widget.onConfirmAsync != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onConfirmAsync!();
        if (mounted && widget.popOnConfirm) {
          Navigator.of(context).pop();
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
      return;
    }

    widget.onConfirm?.call();
    if (widget.popOnConfirm && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dialog = AppConfirmDialog(
      title: widget.title,
      confirmText: widget.confirmText,
      cancelText: widget.cancelText,
      svgIcon: widget.svgIcon,
      content: widget.content,
      isLoading: _isLoading,
      popOnConfirm: false,
      onConfirm: _handleConfirm,
    );

    if (widget.sheetMode) {
      return dialog.buildContent(context, isLoading: _isLoading);
    }

    return dialog;
  }
}

abstract final class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget dialog,
    required double width,
    bool barrierDismissible = true,
    bool useSafeArea = true,
    bool blurBarrier = false,
    double blurSigma = 10,
    Color? barrierColor,
  }) {
    return showDialog<T>(
      context: context,
      useSafeArea: useSafeArea,
      barrierDismissible: blurBarrier ? false : barrierDismissible,
      barrierColor:
          blurBarrier ? Colors.transparent : (barrierColor ?? ColorSet.bcColor),
      builder: (dialogContext) {
        final content = Center(
          child: SizedBox(
            width: width,
            child: dialog,
          ),
        );
        if (!blurBarrier) return content;
        return AppDialogBlurScaffold(
          dismissible: barrierDismissible,
          blurSigma: blurSigma,
          child: content,
        );
      },
    );
  }

  static Future<T?> adaptive<T>({
    required BuildContext context,
    required Widget dialog,
    required double width,
    bool barrierDismissible = true,
    bool isDismissible = true,
    bool dragToClose = true,
    Color? bgColor,
  }) {
    if (FormFactor.isPhone) {
      return AppBottomSheet.present<T>(
        context: context,
        isDismissible: isDismissible,
        dragToClose: dragToClose,
        bgColor: bgColor,
        child: dialog,
      );
    }
    return show<T>(
      context: context,
      dialog: dialog,
      width: width,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<T?> confirm<T>({
    required BuildContext context,
    required String title,
    required double width,
    String? confirmText,
    String? cancelText,
    Widget? content,
    String? svgIcon,
    VoidCallback? onConfirm,
    Future<void> Function()? onConfirmAsync,
    bool popOnConfirm = true,
    Color? barrierColor,
  }) {
    final dialog = _AppConfirmDialogHost(
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      svgIcon: svgIcon,
      content: content,
      onConfirm: onConfirm,
      onConfirmAsync: onConfirmAsync,
      popOnConfirm: popOnConfirm,
      sheetMode: FormFactor.isPhone,
    );

    if (FormFactor.isPhone) {
      return AppBottomSheet.show<T>(
        context: context,
        showCloseButton: false,
        child: dialog,
      );
    }

    return show<T>(
      context: context,
      dialog: dialog,
      width: width,
      barrierColor: barrierColor,
    );
  }

  /// [storeCreditBalance] is only offered as a toggle when it's non-null and
  /// positive — a paid event with no spendable credit shows the plain
  /// confirm dialog, unchanged. [onConfirm] receives whether the user turned
  /// the toggle on at the moment they tapped Join.
  static Future<T?> joinEvent<T>({
    required BuildContext context,
    required String eventTitle,
    required double width,
    StoreCreditBalance? storeCreditBalance,
    void Function(bool useStoreCredit)? onConfirm,
  }) {
    final useStoreCreditNotifier = ValueNotifier<bool>(false);
    final showStoreCredit = storeCreditBalance?.hasCredit == true;

    return show<T>(
      context: context,
      width: width,
      dialog: AppConfirmDialog(
        title: AppLocalizations.of(context)!.joinEventConfirmTitle,
        confirmText: AppLocalizations.of(context)!.joinLabel,
        content: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                eventTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLargeSemiBold.copyWith(
                  color: ColorSet.subTextColor,
                ),
              ),
              if (showStoreCredit) ...[
                const Gap(16),
                StoreCreditToggle(
                  balance: storeCreditBalance!,
                  notifier: useStoreCreditNotifier,
                ),
              ],
            ],
          ),
        ),
        onConfirm: () => onConfirm?.call(useStoreCreditNotifier.value),
      ),
    );
  }

  static Future<T?> attach<T>({
    required BuildContext context,
    required Widget dialog,
    Alignment? alignment,
    bool barrierDismissible = true,
    void Function()? onDismiss,
    Offset Function(Offset, Size)? targetBuilder,
  }) {
    return SmartDialog.showAttach<T>(
      targetContext: context,
      useAnimation: true,
      alignment: alignment,
      builder: (context) => dialog,
      targetBuilder: targetBuilder,
      onDismiss: onDismiss,
      maskColor: ColorSet.bcColor,
    );
  }
}
