import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class OnboardingAvatarPicker extends StatelessWidget {
  const OnboardingAvatarPicker({
    super.key,
    required this.imagePath,
    required this.isLoading,
    required this.onTap,
    this.onClear,
  });

  final String? imagePath;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  static const double _size = 108;

  bool get _hasImage => imagePath != null && imagePath!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: _size.r,
                height: _size.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _hasImage ? Colors.transparent : ColorSet.tileFillColor,
                ),
                child: ClipOval(
                  child: _buildAvatarContent(),
                ),
              ),
              if (_hasImage && onClear != null && !isLoading)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onClear,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.r,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 32.r,
                  height: 32.r,
                  decoration: BoxDecoration(
                    color: ColorSet.revbg3Color,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorSet.bg3Color, width: 2),
                  ),
                  child: isLoading
                      ? Padding(
                          padding: EdgeInsets.all(6.r),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorSet.bg3Color,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt_outlined,
                          color: ColorSet.bg3Color,
                          size: 16.r,
                        ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          AppStrings.onboardingAvatarHint,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.subTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarContent() {
    if (isLoading && !_hasImage) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_hasImage) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Center(
      child: KumeleAssetWidget(
        assetPath: SVGAsset.icon_profile,
        color: ColorSet.subTextColor,
        width: _size * 0.45,
        height: _size * 0.45,
      ),
    );
  }
}
