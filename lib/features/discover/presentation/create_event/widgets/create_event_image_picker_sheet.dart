import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return AppBottomSheet.show<void>(
      context: context,
      title: 'Upload Image',
      subtitle: 'Choose a source for your event image',
      child: CreateEventImagePickerSheet(onSourceSelected: onSourceSelected),
    );
  }

  void _selectSource(BuildContext context, ImagePickerSource source) {
    Navigator.of(context).pop();
    onSourceSelected(source);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton.primary(
          label: 'Gallery',
          fullWidth: true,
          onPressed: () => _selectSource(context, ImagePickerSource.gallery),
        ),
        const Gap(12),
        AppButton.secondary(
          label: 'Camera',
          fullWidth: true,
          onPressed: () => _selectSource(context, ImagePickerSource.camera),
        ),
      ],
    );
  }
}
