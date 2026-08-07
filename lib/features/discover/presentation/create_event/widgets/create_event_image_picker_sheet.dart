import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/services/image_picker/image_picker_service.dart';

class CreateEventImagePickerSheet extends StatelessWidget {
  const CreateEventImagePickerSheet({
    super.key,
    required this.onSourceSelected,
  });

  final ValueChanged<ImagePickerSource> onSourceSelected;

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<ImagePickerSource> onSourceSelected,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return AppBottomSheet.show<void>(
      context: context,
      title: l10n.createEventUploadImageTitle,
      subtitle: l10n.createEventUploadImageSubtitle,
      child: CreateEventImagePickerSheet(onSourceSelected: onSourceSelected),
    );
  }

  void _selectSource(BuildContext context, ImagePickerSource source) {
    Navigator.of(context).pop();
    onSourceSelected(source);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: l10n.gallery,
          fullWidth: true,
          onPressed: () => _selectSource(context, ImagePickerSource.gallery),
        ),
        const Gap(12),
        AppButton.secondary(
          label: l10n.camera,
          fullWidth: true,
          onPressed: () => _selectSource(context, ImagePickerSource.camera),
        ),
      ],
    );
  }
}
