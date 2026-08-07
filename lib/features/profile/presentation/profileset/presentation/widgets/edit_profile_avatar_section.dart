import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class EditProfileAvatarSection extends StatelessWidget {
  const EditProfileAvatarSection({
    super.key,
    required this.displayName,
    required this.avatarUrl,
    required this.localImagePath,
    required this.isLoading,
    required this.onTap,
    this.onClear,
  });

  final String displayName;
  final String? avatarUrl;
  final String? localImagePath;
  final bool isLoading;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  static const double _size = 96;

  bool get _hasLocalImage =>
      localImagePath != null && localImagePath!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isLoading ? null : onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildAvatar(context),
              if (_hasLocalImage && onClear != null && !isLoading)
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
          AppLocalizations.of(context)!.onboardingAvatarHint,
          style: context.textTheme.bodyMedium.copyWith(
            color: ColorSet.subTextColor,
          ),
        ),
        if (displayName.trim().isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            displayName.trim(),
            style: context.textTheme.titleMedium.copyWith(fontSize: 20),
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (_hasLocalImage) {
      return ClipOval(
        child: Image.file(
          File(localImagePath!),
          width: _size.r,
          height: _size.r,
          fit: BoxFit.cover,
        ),
      );
    }

    if (avatarUrl != null && avatarUrl!.trim().isNotEmpty) {
      return AppAvatar(
        imageUrl: avatarUrl,
        name: displayName,
        size: _size,
        showShadow: false,
      );
    }

    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: _size.r,
      height: _size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorSet.tileFillColor,
      ),
      child: Center(
        child: KumeleAssetWidget(
          assetPath: SVGAsset.icon_profile,
          color: ColorSet.subTextColor,
          width: _size * 0.45,
          height: _size * 0.45,
        ),
      ),
    );
  }
}
