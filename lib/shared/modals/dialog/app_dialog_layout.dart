import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/close_keyboard_widget.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/widgets/app_rounded_icon_button.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:lottie/lottie.dart';

/// Shared sizing for modal dialogs across the app.
abstract final class AppDialogSize {
  static const double minWidth = 340;
  static const double maxWidth = 520;
  static const double minHeight = 326;

  static double widthFor(BuildContext context) {
    final responsive = context.responsive;
    final horizontalInset = responsive.horizontalPadding * 2;
    final availableWidth = responsive.screenSize.width - horizontalInset;

    final preferredWidth =
        responsive.isPhone ? availableWidth : responsive.longestSide * 45 / 100;

    return preferredWidth
        .clamp(minWidth, maxWidth)
        .clamp(0, availableWidth)
        .roundToDouble();
  }

  static double maxHeightFor(BuildContext context) {
    return (context.responsive.screenSize.height * 6 / 10).roundToDouble();
  }
}

class AppDialogContent extends StatelessWidget {
  const AppDialogContent({
    super.key,
    required this.title,
    required this.onContinue,
    required this.child,
    this.isLoading = false,
  });

  final String title;
  final VoidCallback onContinue;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: AppDialogSize.minHeight,
        maxHeight: AppDialogSize.maxHeightFor(context),
      ),
      decoration: ShapeDecoration(
        color: ColorSet.bg2Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
        ),
      ),
      child: CloseKeyboard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(40.w),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.textTheme.heading3.copyWith(
                      color: ColorSet.textColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                AppRoundedIconButton(
                  assetPath: IconSet.closeIcon,
                  iconSize: 20,
                  semanticLabel: 'Close',
                  onTap: () => context.pop(),
                ),
              ],
            ),
            const Gap(24),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: child,
              ),
            ),
            Gap(24.h),
            AppButton.primary(
              label: AppStrings.continueLabel,
              isLoading: isLoading,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

class AppTitledDialog extends StatelessWidget {
  const AppTitledDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.header,
    required this.child,
    this.footer,
    this.showClose = true,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? header;
  final Widget child;
  final Widget? footer;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: AppDialogSize.minHeight,
        maxHeight: AppDialogSize.maxHeightFor(context),
      ),
      decoration: ShapeDecoration(
        color: ColorSet.bg2Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header ?? _buildDefaultHeader(context),
          const Gap(24),
          Flexible(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          if (footer != null) ...[
            Gap(24.h),
            footer!,
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(40.w),
        Expanded(
          child: titleWidget ??
              Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: context.textTheme.heading3.copyWith(
                  color: ColorSet.textColor,
                  fontSize: 20,
                ),
              ),
        ),
        if (showClose)
          AppRoundedIconButton(
            assetPath: IconSet.closeIcon,
            iconSize: 20,
            semanticLabel: 'Close',
            onTap: () => context.pop(),
          )
        else
          SizedBox(width: 40.w),
      ],
    );
  }
}

class AppScrollDialog extends StatelessWidget {
  const AppScrollDialog({
    super.key,
    required this.child,
    this.footer,
    this.showClose = false,
  });

  final Widget child;
  final Widget? footer;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: AppDialogSize.minHeight,
        maxHeight: AppDialogSize.maxHeightFor(context),
      ),
      decoration: ShapeDecoration(
        color: ColorSet.bg2Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showClose)
            Align(
              alignment: Alignment.centerRight,
              child: AppRoundedIconButton(
                assetPath: IconSet.closeIcon,
                iconSize: 20,
                semanticLabel: 'Close',
                onTap: () => context.pop(),
              ),
            ),
          if (showClose) const Gap(24),
          Flexible(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          if (footer != null) ...[
            Gap(24.h),
            footer!,
          ],
        ],
      ),
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    this.confirmText,
    this.content,
    this.onConfirm,
    this.svgIcon,
    this.isLoading = false,
    this.popOnConfirm = true,
  });

  final String title;
  final String? confirmText;
  final Widget? content;
  final VoidCallback? onConfirm;
  final String? svgIcon;
  final bool isLoading;
  final bool popOnConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: AppDialogSize.minHeight,
        maxHeight: AppDialogSize.maxHeightFor(context),
      ),
      decoration: ShapeDecoration(
        color: ColorSet.bg2Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
        ),
      ),
      child: buildContent(context, isLoading: isLoading),
    );
  }

  Widget buildContent(BuildContext context, {bool isLoading = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.textTheme.titleLargeBold,
          textAlign: TextAlign.center,
        ),
        const Gap(20),
        svgIcon != null
            ? KumeleAssetWidget(
                assetPath: svgIcon!,
                height: 98,
                width: 98,
                color: ColorSet.tileFontColor,
              )
            : Lottie.asset(
                IconSet.jsonImportant,
                height: 98,
                width: 98,
                fit: BoxFit.fill,
              ),
        content ?? const SizedBox.shrink(),
        const Gap(20),
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: AppButton.primary(
                label: AppStrings.cancel,
                onPressed: isLoading ? null : () => context.pop(),
              ),
            ),
            Expanded(
              child: AppButton.primary(
                label: confirmText ?? AppStrings.confirm,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        onConfirm?.call();
                        if (popOnConfirm) {
                          context.pop();
                        }
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AppDialogLayout extends StatelessWidget {
  const AppDialogLayout({
    super.key,
    required this.child,
    required this.widthPercent,
    required this.heightPercent,
    this.backgroundImagePath,
    this.showImageOverlay = true,
  });

  final Widget child;
  final double widthPercent;
  final double heightPercent;
  final String? backgroundImagePath;
  final bool showImageOverlay;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final dialogWidth = (responsive.longestSide * widthPercent).roundToDouble();
    final dialogHeight = ((responsive.isTablet
                ? responsive.shortestSide
                : responsive.longestSide) *
            heightPercent)
        .roundToDouble();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding,
        vertical: responsive.verticalPadding,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(responsive.w(20).roundToDouble()),
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (backgroundImagePath != null)
                KumeleAssetWidget(
                  assetPath: backgroundImagePath!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              if (showImageOverlay)
                ColoredBox(
                  color: ColorSet.revbg3Color.withValues(alpha: 45 / 100),
                )
              else
                ColoredBox(color: ColorSet.bg3Color),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class AppDialogBlurScaffold extends StatelessWidget {
  const AppDialogBlurScaffold({
    super.key,
    required this.child,
    required this.dismissible,
    this.blurSigma = 10,
  });

  final Widget child;
  final bool dismissible;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: dismissible ? () => Navigator.of(context).pop() : null,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurSigma,
                  sigmaY: blurSigma,
                ),
                child: ColoredBox(color: ColorSet.bcColor),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
