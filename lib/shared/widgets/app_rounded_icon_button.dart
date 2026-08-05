import 'package:flutter/material.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_loading_indicator.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:lottie/lottie.dart';

/// A small circular tap target that displays an asset icon.
///
/// The outer circle size is derived automatically from [iconSize] plus
/// [padding] on every side, so the tap target grows with the icon.
class AppRoundedIconButton extends StatefulWidget {
  const AppRoundedIconButton({
    super.key,
    required this.assetPath,
    this.onTap,
    this.iconSize = 24,
    this.padding = 8,
    this.backgroundColor,
    this.pressedColor,
    this.borderColor,
    this.iconColor,
    this.semanticLabel,
    this.isLoading = false,
  });

  final String assetPath;
  final VoidCallback? onTap;
  final double iconSize;

  /// Space between the icon and the edge of the circle, applied on all sides.
  final double padding;
  final Color? backgroundColor;
  final Color? pressedColor;
  final Color? borderColor;
  final Color? iconColor;
  final String? semanticLabel;
  final bool isLoading;

  @override
  State<AppRoundedIconButton> createState() => _AppRoundedIconButtonState();
}

class _AppRoundedIconButtonState extends State<AppRoundedIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scaledIconSize = _scaledSize(context, widget.iconSize);
    final scaledSize =
        scaledIconSize + _scaledSize(context, widget.padding) * 2;
    final idleBackground = widget.backgroundColor ?? Colors.transparent;
    final pressedBackground =
        widget.pressedColor ?? widget.backgroundColor ?? ColorSet.tileFillColor;
    final borderColor = widget.borderColor;

    final button = GestureDetector(
      onTapDown:
          widget.onTap == null ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
      onTapCancel:
          widget.onTap == null ? null : () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: scaledSize,
        height: scaledSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _pressed ? pressedBackground : idleBackground,
          border: borderColor == null
              ? null
              : Border.all(
                  color: _pressed ? Colors.transparent : borderColor,
                ),
        ),
        child: _buildIcon(scaledIconSize),
      ),
    );

    if (widget.semanticLabel == null) return button;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: button,
    );
  }

  Widget _buildIcon(double scaledIconSize) {
    if (widget.isLoading) {
      return AppLoadingIndicator.circle(
        size: scaledIconSize,
        color: widget.iconColor ?? ColorSet.specialColor,
      );
    }

    final path = widget.assetPath;

    if (path.toLowerCase().endsWith('.json')) {
      return Lottie.asset(
        path,
        width: scaledIconSize,
        height: scaledIconSize,
        fit: BoxFit.contain,
      );
    }

    return KumeleAssetWidget.square(
      assetPath: path,
      size: scaledIconSize,
      color: widget.iconColor,
      fit: BoxFit.contain,
    );
  }

  double _scaledSize(BuildContext context, double value) {
    return context.responsiveOrNull?.w(value) ?? value;
  }
}
