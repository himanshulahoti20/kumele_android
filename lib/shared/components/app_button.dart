// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ClickWidget extends StatelessWidget {
  final void Function()? onPressed;
  final void Function(BuildContext)? onPressedWithContext;
  final Widget child;

  const ClickWidget({
    super.key,
    required this.onPressed,
    required this.child,
    this.onPressedWithContext,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size(10, 10),
      onPressed: onPressedWithContext != null
          ? () => onPressedWithContext!.call(context)
          : onPressed,
      child: child,
    );
  }
}

enum AppButtonType { primary, secondary, outline, danger, dotted, text, icon }

enum AppButtonSize { lg, md, sm, xs, icon }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.lg,
    this.icon,
    this.iconAsset,
    this.trailing,
    this.iconColor,
    this.iconSize,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor,
    this.fullWidth = true,
    this.isLoading = false,
    this.width,
    this.height,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.bordered = true,
  });

  const AppButton.icon({
    super.key,
    required this.iconAsset,
    this.onPressed,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.bordered = true,
    this.iconSize,
    this.padding,
    this.size = AppButtonSize.icon,
    this.isLoading = false,
  })  : label = '',
        type = AppButtonType.icon,
        icon = null,
        trailing = null,
        foregroundColor = null,
        fullWidth = false,
        width = null,
        height = null,
        fontSize = null,
        borderRadius = null;

  const AppButton._text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconAsset,
    this.trailing,
    this.iconColor,
    this.iconSize,
    this.width,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.foregroundColor,
  })  : type = AppButtonType.text,
        size = AppButtonSize.lg,
        borderColor = null,
        backgroundColor = null,
        fullWidth = true,
        height = null,
        bordered = true;

  factory AppButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.lg,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  factory AppButton.primarySmall({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? iconSize,
    double? width,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.primary,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      iconSize: iconSize,
      width: width,
      fullWidth: false,
      size: AppButtonSize.xs,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  factory AppButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.secondary,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.outline({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.lg,
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
      borderColor: borderColor,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  factory AppButton.danger({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? iconSize,
    double? width,
    double? height,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.danger,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      iconSize: iconSize,
      width: width,
      height: height,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.dangerOutline({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.outline,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: ColorSet.snackBarErrorBg,
      foregroundColor: ColorSet.snackBarErrorBg,
      borderColor: ColorSet.snackBarErrorBg,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      padding: padding,
      borderRadius: borderRadius,
      size: size,
    );
  }

  factory AppButton.dotted({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? width,
    double? height,
    double? fontSize,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
    bool fullWidth = true,
    AppButtonSize size = AppButtonSize.lg,
  }) {
    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      type: AppButtonType.dotted,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      width: width,
      height: height,
      fontSize: fontSize,
      iconSize: iconSize,
      padding: padding,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor,
      borderColor: borderColor,
      fullWidth: fullWidth,
      size: size,
    );
  }

  factory AppButton.text({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    String? iconAsset,
    Widget? trailing,
    Color? iconColor,
    double? iconSize,
    double? width,
    double? fontSize,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    Color? foregroundColor,
  }) {
    return AppButton._text(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      iconAsset: iconAsset,
      trailing: trailing,
      iconColor: iconColor,
      iconSize: iconSize,
      width: width,
      fontSize: fontSize,
      padding: padding ?? EdgeInsets.zero,
      borderRadius: borderRadius,
      foregroundColor: foregroundColor,
    );
  }

  factory AppButton.back({
    Key? key,
    required String iconAsset,
    required VoidCallback? onPressed,
    Color? borderColor,
    Color? iconColor,
  }) {
    return AppButton.icon(
      key: key,
      iconAsset: iconAsset,
      onPressed: onPressed,
      backgroundColor: Colors.transparent,
      borderColor: borderColor ?? ColorSet.border,
      iconColor: iconColor ?? ColorSet.textColor,
      iconSize: 20.r,
    );
  }

  factory AppButton.close({
    Key? key,
    required VoidCallback? onPressed,
    required String iconAsset,
    Color iconColor = Colors.white,
    double? iconSize,
    EdgeInsetsGeometry? padding,
  }) {
    return AppButton.icon(
      key: key,
      iconAsset: iconAsset,
      onPressed: onPressed,
      bordered: false,
      iconColor: iconColor,
      iconSize: iconSize ?? 28.r,
      padding: padding ?? EdgeInsets.all(8.r),
    );
  }

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final String? iconAsset;
  final Widget? trailing;
  final Color? iconColor;
  final double? iconSize;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool fullWidth;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool bordered;

  bool get _isDisabled => isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    if (type == AppButtonType.icon) {
      return _AppIconButtonView(
        iconAsset: iconAsset,
        onPressed: onPressed,
        iconColor: iconColor,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        bordered: bordered,
        iconSize: iconSize,
        padding: padding,
        isLoading: isLoading,
      );
    }

    if (type == AppButtonType.text) {
      return _buildTextButton(context);
    }

    if (type == AppButtonType.dotted) {
      return _buildDottedButton(context);
    }

    return _buildFilledButton(context);
  }

  Widget _buildTextButton(BuildContext context) {
    final isDisabled = _isDisabled;
    final effectivePadding = padding ?? EdgeInsets.zero;
    final effectiveFontSize = fontSize ?? 14.sp;
    final resolvedIconSize = iconSize ?? 16.r;
    final baseForeground =
        foregroundColor ?? iconColor ?? ColorSet.lightBlueColor;
    final contentColor = isDisabled ? ColorSet.subTextColor : baseForeground;

    final labelStyle = context.textTheme.bodyMediumSemiBold.copyWith(
      color: contentColor,
      fontSize: effectiveFontSize,
      fontWeight: FontWeight.w500,
      height: 1.0,
    );

    final content = _buildContentRow(
      context: context,
      contentColor: contentColor,
      labelStyle: labelStyle,
      resolvedIconSize: resolvedIconSize,
      mainAxisSize: MainAxisSize.min,
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        child: Padding(
          padding: effectivePadding,
          child: width != null
              ? SizedBox(
                  width: width!.w, child: _loadingStack(content, contentColor))
              : _loadingStack(content, contentColor),
        ),
      ),
    );
  }

  Widget _buildFilledButton(BuildContext context) {
    final metrics = _resolveMetrics(size);
    final colors = _colorsFor(type);
    final isDisabled = _isDisabled;
    final resolvedIconSize = iconSize ?? metrics.iconSize;
    final resolvedBackground = _resolveBackground(
      backgroundColor ?? colors.background,
      type,
      isDisabled,
    );
    final resolvedForeground = _resolveForeground(
      foregroundColor ?? colors.foreground,
      type,
      isDisabled,
    );
    final resolvedBorder = borderColor ?? colors.border;
    final effectivePadding = padding ?? metrics.padding;
    final effectiveFontSize = fontSize ?? metrics.fontSize;
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(metrics.borderRadius);
    final effectiveHeight = height ?? metrics.height;

    final labelStyle = context.textTheme.bodyLargeSemiBold.copyWith(
      color: resolvedForeground,
      fontSize: effectiveFontSize,
      fontWeight: FontWeight.w400,
      height: 1.0,
    );

    final content = _buildContentRow(
      context: context,
      contentColor: resolvedForeground,
      labelStyle: labelStyle,
      resolvedIconSize: resolvedIconSize,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      ellipsis: fullWidth,
    );

    final decoration = BoxDecoration(
      color: resolvedBackground,
      borderRadius: effectiveRadius,
      border: colors.borderWidth > 0
          ? Border.all(color: resolvedBorder, width: colors.borderWidth)
          : null,
    );

    final child = _loadingStack(content, resolvedForeground);
    final effectiveWidth = fullWidth ? double.infinity : width?.w;

    return Material(
      color: Colors.transparent,
      child: effectiveWidth != null
          ? SizedBox(
              width: effectiveWidth,
              height: effectiveHeight,
              child: Ink(
                decoration: decoration,
                child: InkWell(
                  onTap: isDisabled ? null : onPressed,
                  borderRadius: effectiveRadius,
                  child: Container(
                    padding: effectivePadding,
                    alignment: Alignment.center,
                    child: child,
                  ),
                ),
              ),
            )
          : Ink(
              decoration: decoration,
              child: InkWell(
                onTap: isDisabled ? null : onPressed,
                borderRadius: effectiveRadius,
                child: SizedBox(
                  height: effectiveHeight,
                  child: Padding(
                    padding: effectivePadding,
                    child: child,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDottedButton(BuildContext context) {
    final colors = _colorsFor(AppButtonType.dotted);
    final isDisabled = _isDisabled;
    final resolvedIconSize = iconSize ?? 20.r;
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(8.r);
    final resolvedForeground = foregroundColor ?? colors.foreground;
    final resolvedBackground = backgroundColor ?? colors.background;
    final resolvedBorder = borderColor ?? colors.border;
    final effectiveFontSize = fontSize ?? 15.sp;
    final contentColor =
        isDisabled ? ColorSet.subTextColor : resolvedForeground;

    final labelStyle = context.textTheme.bodyLargeSemiBold.copyWith(
      color: contentColor,
      fontWeight: FontWeight.w600,
      fontSize: effectiveFontSize,
      letterSpacing: 0.3,
      height: 1.0,
    );

    final content = _buildContentRow(
      context: context,
      contentColor: contentColor,
      labelStyle: labelStyle,
      resolvedIconSize: resolvedIconSize,
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      displayLabel: label.toUpperCase(),
    );

    return SizedBox(
      width: fullWidth ? double.infinity : width?.w,
      height: height,
      child: CustomPaint(
        painter: _DottedBorderPainter(
          borderColor: resolvedBorder,
          borderRadius: effectiveRadius,
          strokeWidth: 1.5,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            borderRadius: effectiveRadius,
            child: Ink(
              decoration: BoxDecoration(
                color: resolvedBackground,
                borderRadius: effectiveRadius,
              ),
              padding: effectivePadding,
              child: _loadingStack(content, contentColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentRow({
    required BuildContext context,
    required Color contentColor,
    required TextStyle labelStyle,
    required double resolvedIconSize,
    required MainAxisSize mainAxisSize,
    String? displayLabel,
    bool ellipsis = false,
  }) {
    final text = displayLabel ?? label;

    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconAsset != null) ...[
          KumeleAssetWidget.square(
            assetPath: iconAsset!,
            size: resolvedIconSize,
            color: iconColor ?? contentColor,
          ),
          if (text.isNotEmpty) SizedBox(width: 8.w),
        ] else if (icon != null) ...[
          Icon(icon, size: resolvedIconSize, color: iconColor ?? contentColor),
          if (text.isNotEmpty) SizedBox(width: 8.w),
        ],
        if (text.isNotEmpty)
          ellipsis
              ? Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    text,
                    style: labelStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                )
              : Text(text, style: labelStyle, textAlign: TextAlign.center),
        if (trailing != null) ...[
          if (text.isNotEmpty) SizedBox(width: 8.w),
          trailing!,
        ],
      ],
    );
  }

  Widget _loadingStack(Widget content, Color indicatorColor) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Opacity(opacity: isLoading ? 0.0 : 1.0, child: content),
        if (isLoading)
          SizedBox(
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: indicatorColor,
            ),
          ),
      ],
    );
  }

  Color _resolveBackground(
      Color base, AppButtonType buttonType, bool isDisabled) {
    if (!isDisabled) return base;
    return switch (buttonType) {
      AppButtonType.outline || AppButtonType.text => base,
      _ => base.withValues(alpha: 0.5),
    };
  }

  Color _resolveForeground(
      Color base, AppButtonType buttonType, bool isDisabled) {
    if (!isDisabled) return base;
    return switch (buttonType) {
      AppButtonType.outline ||
      AppButtonType.text ||
      AppButtonType.dotted =>
        ColorSet.subTextColor,
      _ => Colors.white70,
    };
  }

  _AppButtonColors _colorsFor(AppButtonType buttonType) {
    return switch (buttonType) {
      AppButtonType.primary => _AppButtonColors(
          background: ColorSet.revbg3Color,
          foreground: ColorSet.bg2Color,
        ),
      AppButtonType.secondary => _AppButtonColors(
          background: ColorSet.tileFillColor,
          foreground: ColorSet.textColor,
          border: ColorSet.border,
          borderWidth: 2,
        ),
      AppButtonType.outline => _AppButtonColors(
          background: ColorSet.bgColor,
          foreground: ColorSet.revertBgColor,
          border: ColorSet.revertBgColor,
        ),
      AppButtonType.danger => _AppButtonColors(
          background: ColorSet.snackBarErrorBg,
          foreground: ColorSet.snackBarErrorText,
        ),
      AppButtonType.dotted => _AppButtonColors(
          background: Colors.transparent,
          foreground: ColorSet.specialBlueColor,
          border: ColorSet.border,
        ),
      AppButtonType.text || AppButtonType.icon => _AppButtonColors(),
    };
  }

  _AppButtonMetrics _resolveMetrics(AppButtonSize buttonSize) {
    return switch (buttonSize) {
      AppButtonSize.lg => _AppButtonMetrics(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          fontSize: 15.sp,
          iconSize: 20.r,
          height: 50.h,
          borderRadius: 8.r,
        ),
      AppButtonSize.md => _AppButtonMetrics(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          fontSize: 15.sp,
          iconSize: 20.r,
          height: 46.h,
          borderRadius: 8.r,
        ),
      AppButtonSize.sm => _AppButtonMetrics(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          fontSize: 14.sp,
          iconSize: 18.r,
          height: 40.h,
          borderRadius: 8.r,
        ),
      AppButtonSize.xs => _AppButtonMetrics(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          fontSize: 12.sp,
          iconSize: 14.r,
          height: 30.h,
          borderRadius: 6.r,
        ),
      AppButtonSize.icon => _AppButtonMetrics(
          padding: EdgeInsets.zero,
          fontSize: 14.sp,
          iconSize: 24.r,
          height: 40.r,
          borderRadius: 8.r,
        ),
    };
  }
}

class _AppIconButtonView extends StatelessWidget {
  const _AppIconButtonView({
    required this.iconAsset,
    this.onPressed,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.bordered = true,
    this.iconSize,
    this.padding,
    this.isLoading = false,
  });

  final String? iconAsset;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool bordered;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  Widget _iconContent(double resolvedSize, Color indicatorColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0.0 : 1.0,
          child: iconAsset == null
              ? const SizedBox.shrink()
              : KumeleAssetWidget.square(
                  assetPath: iconAsset!,
                  size: resolvedSize,
                  color: iconColor,
                ),
        ),
        if (isLoading)
          SizedBox(
            width: resolvedSize * 0.65,
            height: resolvedSize * 0.65,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: indicatorColor,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = iconColor ?? ColorSet.specialBlueColor;

    if (!bordered) {
      final resolvedSize = iconSize ?? 32.r;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(4.r),
          child: Padding(
            padding: padding ?? EdgeInsets.all(2.r),
            child: SizedBox(
              width: resolvedSize,
              height: resolvedSize,
              child: _iconContent(resolvedSize, indicatorColor),
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: backgroundColor ?? ColorSet.tileFillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor ?? ColorSet.border),
          ),
          child: Center(child: _iconContent(iconSize ?? 24.r, indicatorColor)),
        ),
      ),
    );
  }
}

class _AppButtonColors {
  _AppButtonColors({
    this.background = Colors.transparent,
    Color? foreground,
    Color? border,
    this.borderWidth = 1,
  })  : foreground = foreground ?? ColorSet.textColor,
        border = border ?? ColorSet.border;

  final Color background;
  final Color foreground;
  final Color border;
  final double borderWidth;
}

class _AppButtonMetrics {
  const _AppButtonMetrics({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.height,
    required this.borderRadius,
  });

  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final double height;
  final double borderRadius;
}

class _DottedBorderPainter extends CustomPainter {
  const _DottedBorderPainter({
    required this.borderColor,
    required this.borderRadius,
    required this.strokeWidth,
  });

  final Color borderColor;
  final BorderRadius borderRadius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()..addRRect(borderRadius.toRRect(rect));
    const dashLength = 6.0;
    const dashGap = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
