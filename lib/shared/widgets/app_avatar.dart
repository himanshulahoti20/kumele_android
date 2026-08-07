import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    required this.size,
    this.backgroundColor,
    this.textColor,
    this.border,
    this.fit = BoxFit.cover,
    this.semanticLabel,
    this.showShadow = true,
    this.previewOnTap = false,
    this.onTap,
    this.onEditTap,
    this.editIconAsset,
  });

  final String? imageUrl;
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final BoxBorder? border;
  final BoxFit fit;
  final String? semanticLabel;
  final bool showShadow;
  final bool previewOnTap;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;
  final String? editIconAsset;

  static Future<void> showImagePreview(
    BuildContext context, {
    required String imageUrl,
    String? name,
    double blurSigma = 12,
  }) {
    if (!_isValidImageUrl(imageUrl)) return Future.value();

    return showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (dialogContext) => _AppAvatarPreviewDialog(
        imageUrl: imageUrl.trim(),
        name: name,
        blurSigma: blurSigma,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaledSize = _scaledSize(context);
    final avatar = _buildAvatar(context, scaledSize);
    final interactiveAvatar = _wrapWithTap(context, avatar);
    return _wrapWithEditBadge(context, interactiveAvatar);
  }

  Widget _wrapWithTap(BuildContext context, Widget avatar) {
    final tapHandler = _resolveTapHandler(context);
    if (tapHandler == null) return avatar;

    return Semantics(
      button: true,
      label: semanticLabel ?? name,
      child: GestureDetector(
        onTap: tapHandler,
        child: avatar,
      ),
    );
  }

  Widget _wrapWithEditBadge(BuildContext context, Widget avatar) {
    if (onEditTap == null || editIconAsset == null) return avatar;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -2.w,
          bottom: -2.h,
          child: AppRoundedIconButton(
            assetPath: editIconAsset!,
            iconSize: 14,
            padding: 6,
            backgroundColor: ColorSet.bg3Color,
            borderColor: ColorSet.border,
            iconColor: ColorSet.textColor,
            onTap: onEditTap,
            semanticLabel: AppLocalizations.of(context)!.edit,
          ),
        ),
      ],
    );
  }

  VoidCallback? _resolveTapHandler(BuildContext context) {
    if (onTap != null) return onTap;

    if (!previewOnTap || !_isValidImageUrl(imageUrl)) return null;

    return () => showImagePreview(
          context,
          imageUrl: imageUrl!,
          name: name,
        );
  }

  Widget _buildAvatar(BuildContext context, double scaledSize) {
    final initialsWidget = _AppAvatarInitials(
      name: name,
      size: scaledSize,
      backgroundColor: backgroundColor,
      textColor: textColor,
      border: border,
    );

    final Widget avatarChild;
    if (!_isValidImageUrl(imageUrl)) {
      avatarChild = initialsWidget;
    } else {
      avatarChild = _AppAvatarNetworkImage(
        imageUrl: imageUrl!.trim(),
        size: scaledSize,
        fit: fit,
        border: border,
        semanticLabel: semanticLabel ?? name,
        errorWidget: initialsWidget,
      );
    }

    if (!showShadow) {
      return avatarChild;
    }

    return _AppAvatarShadow(
      size: scaledSize,
      child: avatarChild,
    );
  }

  double _scaledSize(BuildContext context) {
    return context.responsiveOrNull?.w(size) ?? size;
  }

  static bool _isValidImageUrl(String? value) {
    if (value == null) return false;

    final url = value.trim();
    if (url.isEmpty) return false;

    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}

class _AppAvatarPreviewDialog extends StatelessWidget {
  const _AppAvatarPreviewDialog({
    required this.imageUrl,
    required this.blurSigma,
    this.name,
  });

  final String imageUrl;
  final String? name;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final previewSize =
        (MediaQuery.sizeOf(context).width * 0.72).clamp(220.0, 320.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurSigma,
                  sigmaY: blurSigma,
                ),
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: previewSize,
                  height: previewSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _AppAvatarSkeleton(
                        size: previewSize,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: ColorSet.hostTileColor,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person_outline,
                          size: previewSize * 0.35,
                          color: ColorSet.subTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                if (name != null && name!.trim().isNotEmpty) ...[
                  Gap(16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      name!.trim(),
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLargeBold.copyWith(
                        color: ColorSet.textColor,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppAvatarNetworkImage extends StatelessWidget {
  const _AppAvatarNetworkImage({
    required this.imageUrl,
    required this.size,
    required this.fit,
    required this.errorWidget,
    this.border,
    this.semanticLabel,
  });

  final String imageUrl;
  final double size;
  final BoxFit fit;
  final Widget errorWidget;
  final BoxBorder? border;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final image = ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          placeholder: (context, url) => _AppAvatarSkeleton(
            size: size,
            border: border,
          ),
          errorWidget: (context, url, error) => errorWidget,
        ),
      ),
    );

    if (semanticLabel == null) return image;

    return Semantics(
      label: semanticLabel,
      image: true,
      child: image,
    );
  }
}

class _AppAvatarSkeleton extends StatelessWidget {
  const _AppAvatarSkeleton({
    required this.size,
    this.border,
  });

  final double size;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorSet.hostTileColor,
          border: border,
        ),
      ),
    );
  }
}

class _AppAvatarShadow extends StatelessWidget {
  const _AppAvatarShadow({
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.avatar,
      ),
      child: child,
    );
  }
}

class _AppAvatarInitials extends StatelessWidget {
  const _AppAvatarInitials({
    required this.name,
    required this.size,
    this.backgroundColor,
    this.textColor,
    this.border,
  });

  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFromName(name);
    final fontSize = (size * 0.36).clamp(12.0, 48.0);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? ColorSet.bgColor,
        border: border,
      ),
      child: Text(
        initials,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: context.textTheme.headlineSmallBold.copyWith(
          fontSize: fontSize,
          color: textColor ?? ColorSet.textColor,
          height: 1,
        ),
      ),
    );
  }

  static String _initialsFromName(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      if (word.length >= 2) {
        return word.substring(0, 2).toUpperCase();
      }
      return word[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
