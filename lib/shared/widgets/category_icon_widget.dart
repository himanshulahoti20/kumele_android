import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

/// Central renderer for a category/hobby `icon` coming from the backend.
///
/// The API sends `icon` as either a plain emoji string (e.g. `"⚽"`) or a
/// real asset path/URL, and an optional hex `color` (e.g. `"#22c55e"`) used
/// as a soft badge behind the icon. Every screen that shows a hobby or event
/// category (onboarding, create event, blog filters, ...) should render
/// through this widget instead of re-implementing the emoji/asset check.
class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({
    super.key,
    required this.icon,
    required this.size,
    this.iconDark,
    this.color,
    this.badgeColor,
  });

  final String? icon;

  /// Backend's dark-mode variant of [icon]. Backend's light/dark assignment
  /// is currently swapped, so this is shown in *light* mode and [icon] in
  /// dark mode until the asset is fixed upstream — remove the swap once it
  /// is.
  final String? iconDark;
  final double size;

  /// Tint applied to non-emoji (SVG/asset) icons.
  final Color? color;

  /// Hex string (e.g. `"#22c55e"`) painted as a soft circular badge behind
  /// the icon. Ignored if null/empty.
  final String? badgeColor;

  @override
  Widget build(BuildContext context) {
    final value = ColorSet.isDarkMode ? (icon ?? iconDark) : (iconDark ?? icon);
    final isEmoji =
        value != null && value.isNotEmpty && !value.contains('/') && !value.contains('.');

    final Widget child;
    if (value == null || value.isEmpty) {
      child = SizedBox(width: size, height: size);
    } else if (isEmoji) {
      child = Center(
        child: Text(
          value,
          style: TextStyle(fontSize: size * 0.6, height: 1.0),
        ),
      );
    } else {
      child = KumeleAssetWidget(
        assetPath: value,
        width: size,
        height: size,
        color: color,
      );
    }

    if (Utils.isNullOrEmpty(badgeColor)) {
      return SizedBox(width: size, height: size, child: child);
    }

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badgeColor.toColor().withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
