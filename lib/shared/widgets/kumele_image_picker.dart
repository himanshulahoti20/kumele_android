import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/dot_border.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class KumeleImagePicker extends StatelessWidget {
  const KumeleImagePicker({
    super.key,
    required this.height,
    this.imagePath,
    this.isLoading = false,
    this.onTap,
    this.onClear,
    this.placeholderText = 'Upload an image',
    this.unsupportedPlatformText = 'Image upload available on Android',
    this.uploadIconPath,
  });

  final double height;
  final String? imagePath;
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final String placeholderText;
  final String unsupportedPlatformText;
  final String? uploadIconPath;

  bool get _canPick => Platform.isAndroid && onTap != null;

  bool get _hasImage => imagePath != null && imagePath!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _canPick && !isLoading ? onTap : null,
      child: RADottedBorderContainer(
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: _hasImage
              ? _ImagePreview(
                  imagePath: imagePath!,
                  isLoading: isLoading,
                  onClear: onClear,
                )
              : _EmptyState(
                  isLoading: isLoading,
                  canPick: _canPick,
                  placeholderText: placeholderText,
                  unsupportedPlatformText: unsupportedPlatformText,
                  uploadIconPath:
                      uploadIconPath ?? Assets.icons.uploadImage.path,
                ),
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.imagePath,
    required this.isLoading,
    this.onClear,
  });

  final String imagePath;
  final bool isLoading;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size(8)),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        if (isLoading)
          const ColoredBox(
            color: Colors.black26,
            child: Center(child: CircularProgressIndicator()),
          ),
        if (onClear != null && !isLoading)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.isLoading,
    required this.canPick,
    required this.placeholderText,
    required this.unsupportedPlatformText,
    required this.uploadIconPath,
  });

  final bool isLoading;
  final bool canPick;
  final String placeholderText;
  final String unsupportedPlatformText;
  final String uploadIconPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isLoading)
          const CircularProgressIndicator()
        else ...[
          KumeleAssetWidget.square(
            assetPath: uploadIconPath,
            size: 19,
            fit: BoxFit.fill,
          ),
          const Gap(3),
          Text(
            canPick ? placeholderText : unsupportedPlatformText,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmallSemiBold.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorSet.tileFontColor,
            ),
          ),
        ],
      ],
    );
  }
}
