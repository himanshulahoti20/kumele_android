import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class EventCardCancelButton extends StatelessWidget {
  const EventCardCancelButton({super.key});

  static const _cancelWarningSubtitle =
      'Cancelling an event may effect\n how you get matched.Use this\n oprion mindfully';

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      label: AppLocalizations.of(context)!.cancel,
      onPressed: () => _showCancelDialog(context),
      size: AppButtonSize.sm,
      fullWidth: false,
    );
  }

  void _showCancelDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      width: AppDialogSize.widthFor(context),
      dialog: AppDialogContent(
        title: AppLocalizations.of(context)!.cancelEventTitle,
        onContinue: () => context.pop(),
        child: Text(
          _cancelWarningSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
