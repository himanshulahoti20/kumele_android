import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class CreateEventPreviewButton extends StatelessWidget {
  const CreateEventPreviewButton({
    super.key,
    required this.onPressed,
    this.horizontalPadding = 40,
    this.verticalPadding = 15,
  });

  final VoidCallback onPressed;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Utils.isPortrait ? Alignment.center : Alignment.centerRight,
      child: AppButton.primary(
        label: AppLocalizations.of(context)!.previewEventLabel,
        onPressed: onPressed,
        fullWidth: Utils.isPortrait,
      ),
    );
  }
}
