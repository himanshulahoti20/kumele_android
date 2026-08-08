import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';

class EventMatchedGoToChatButton extends StatelessWidget {
  const EventMatchedGoToChatButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final iconSize = responsive.pick(
      mobilePortrait: 22.0,
      tabletPortrait: 24.0,
    );

    return AppButton.primary(
      label: AppLocalizations.of(context)!.discoverGoToChatLabel,
      onPressed: onTap,
      isLoading: isLoading,
      iconAsset: Assets.icons.chats.chat.path,
      iconSize: iconSize,
      fullWidth: false,
    );
  }
}
