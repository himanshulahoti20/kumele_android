import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/utils/device_utils.dart';

/// Matches iOS's PopUpSignOutView exactly — one shared card (no separate
/// _iPhone/_iPad content) with an idiom-conditional shell: phone gets an
/// opaque full-bleed sheet (radius 0, no shadow), tablet floats over a flat
/// scrim with rounded corners and a shadow. Both use the same "layered
/// scrim on phone, flat on tablet" split as PopUpAlert.
class SignOutDialog extends StatefulWidget {
  const SignOutDialog({super.key, required this.onSignOut});

  final Future<void> Function() onSignOut;

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onSignOut,
  }) {
    final dialog = SignOutDialog(onSignOut: onSignOut);

    if (FormFactor.isPhone) {
      return AppBottomSheet.present<void>(
        context: context,
        bgColor: ColorSet.bg2Color,
        child: dialog,
      );
    }

    return AppDialog.show<void>(
      context: context,
      width: AppDialogSize.notificationModalWidthFor(context),
      barrierColor: ColorSet.scrimFlat,
      dialog: dialog,
    );
  }

  @override
  State<SignOutDialog> createState() => _SignOutDialogState();
}

class _SignOutDialogState extends State<SignOutDialog> {
  bool _isSigningOut = false;

  Future<void> _handleSignOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    await widget.onSignOut();
    if (mounted) setState(() => _isSigningOut = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: ColorSet.bg2Color,
        borderRadius:
            FormFactor.isTablet ? BorderRadius.circular(12) : BorderRadius.zero,
        boxShadow: FormFactor.isTablet
            ? const [BoxShadow(blurRadius: 10, color: Colors.black26)]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            IconSet.signOutIcon,
            width: 65,
            height: 65,
            color: ColorSet.textColor,
          ),
          const SizedBox(height: 25),
          Text(
            AppLocalizations.of(context)!.signOutConfirmTitle,
            textAlign: TextAlign.center,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            spacing: 16,
            children: [
              Expanded(
                child: AppButton.primary(
                  label: AppLocalizations.of(context)!.cancel,
                  onPressed:
                      _isSigningOut ? null : () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: AppButton.primary(
                  label: AppLocalizations.of(context)!.signOut,
                  isLoading: _isSigningOut,
                  onPressed: _isSigningOut ? null : _handleSignOut,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
