import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:lottie/lottie.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.child,
    this.children,
    this.footer,
    this.showDragHandle = true,
    this.showCloseButton = true,
    this.scrollable = false,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 32),
    this.onClose,
  }) : assert(
          child != null || children != null,
          'Either child or children must be provided.',
        );

  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? child;
  final List<Widget>? children;
  final Widget? footer;
  final bool showDragHandle;
  final bool showCloseButton;
  final bool scrollable;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onClose;

  static Future<T?> present<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool dragToClose = true,
    EdgeInsetsGeometry? margin,
    Color? bgColor,
  }) {
    const minHeight = 150.0;
    return showModalBottomSheet<T>(
      enableDrag: dragToClose,
      isDismissible: isDismissible,
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: minHeight,
        maxHeight: Utils.getHeight - kToolbarHeight,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      barrierColor: ColorSet.bcColor,
      builder: (BuildContext builder) {
        final bottomInset = MediaQuery.viewInsetsOf(builder).bottom;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            margin: margin,
            decoration: BoxDecoration(
              color: bgColor ?? ColorSet.bg3Color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SafeArea(top: false, child: child),
          ),
        );
      },
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    String? subtitle,
    Widget? child,
    List<Widget>? children,
    Widget? footer,
    bool showDragHandle = true,
    bool showCloseButton = true,
    bool scrollable = false,
    EdgeInsetsGeometry? padding,
    VoidCallback? onClose,
    bool isDismissible = true,
    bool dragToClose = true,
    Color? bgColor,
  }) {
    return present<T>(
      context: context,
      isDismissible: isDismissible,
      dragToClose: dragToClose,
      bgColor: bgColor,
      child: AppBottomSheet(
        title: title,
        titleWidget: titleWidget,
        subtitle: subtitle,
        child: child,
        children: children,
        footer: footer,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        scrollable: scrollable,
        padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 32),
        onClose: onClose,
      ),
    );
  }

  static Future<T?> showPrompt<T>({
    required BuildContext context,
    String title = 'What would you like to do today?',
    required String subtitle,
    required String buttonLabel,
    VoidCallback? onButtonPressed,
    String? iconPath,
    Widget? icon,
    bool isDismissible = true,
    bool dragToClose = true,
    Color? bgColor,
  }) {
    return present<T>(
      context: context,
      isDismissible: isDismissible,
      dragToClose: dragToClose,
      bgColor: bgColor,
      child: AppPromptBottomSheet(
        title: title,
        subtitle: subtitle,
        buttonLabel: buttonLabel,
        onButtonPressed: onButtonPressed,
        iconPath: iconPath,
        icon: icon,
      ),
    );
  }

  bool get _hasHeader =>
      title != null || titleWidget != null || subtitle != null;

  @override
  Widget build(BuildContext context) {
    final content = child ??
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children!,
        );

    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showDragHandle) ...[
            _buildDragHandle(),
            const Gap(16),
          ],
          if (_hasHeader) ...[
            _buildHeader(context),
            const Gap(20),
          ],
          if (scrollable)
            Flexible(
              child: SingleChildScrollView(child: content),
            )
          else
            content,
          if (footer != null) ...[
            const Gap(20),
            footer!,
          ],
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: ColorSet.textColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final closeAction = onClose ?? () => context.pop();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCloseButton) const SizedBox(width: 24),
            Expanded(
              child: titleWidget ??
                  (title != null
                      ? Text(
                          title!,
                          textAlign: TextAlign.center,
                          style:
                              context.textTheme.headlineSmallSemiBold.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : const SizedBox.shrink()),
            ),
            if (showCloseButton)
              GestureDetector(
                onTap: closeAction,
                child: AppSvgImage(
                  assetName: SVGAsset.icon_close,
                  width: 24,
                  height: 24,
                  color: ColorSet.textColor,
                ),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const Gap(12),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMediumSemiBold.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorSet.color525252,
            ),
          ),
        ],
      ],
    );
  }
}

class AppPromptBottomSheet extends StatelessWidget {
  const AppPromptBottomSheet({
    super.key,
    this.title = 'What would you like to do today?',
    required this.subtitle,
    required this.buttonLabel,
    this.onButtonPressed,
    this.iconPath,
    this.icon,
    this.onClose,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback? onButtonPressed;
  final String? iconPath;
  final Widget? icon;
  final VoidCallback? onClose;

  static const double _iconSize = 64;
  static const double _closeSize = 24;
  static const double _horizontalPadding = 24;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final closeAction = onClose ?? () => Navigator.of(context).pop();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        responsive.w(_horizontalPadding),
        responsive.h(24),
        responsive.w(_horizontalPadding),
        responsive.h(32),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(responsive),
              const Spacer(),
              GestureDetector(
                onTap: closeAction,
                child: AppSvgImage(
                  assetName: SVGAsset.icon_close,
                  width: responsive.w(_closeSize),
                  height: responsive.w(_closeSize),
                  color: ColorSet.textColor,
                ),
              ),
            ],
          ),
          Gap(responsive.h(38)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLargeBold.copyWith(
              color: ColorSet.textColor,
            ),
          ),
          Gap(responsive.h(14)),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMediumSemiBold.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorSet.subTextColor,
            ),
          ),
          Gap(responsive.h(21)),
          Center(
            child: AppButton.primary(
              label: buttonLabel,
              onPressed: () {
                Navigator.of(context).pop();
                onButtonPressed?.call();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(ResponsiveData responsive) {
    if (icon != null) return icon!;

    final path = iconPath ?? Assets.gifs.sun.path;
    final size = responsive.w(_iconSize);

    if (path.toLowerCase().endsWith('.json')) {
      return Lottie.asset(
        path,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return KumeleAssetWidget.square(
      assetPath: path,
      size: size,
      fit: BoxFit.contain,
    );
  }
}
