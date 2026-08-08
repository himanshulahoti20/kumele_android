import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_rich_text.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;
  final VoidCallback? linkOnTap;
  final String text;
  final String? linkedText;
  final double? textSize;
  final FontWeight? textWeight;
  final double? size;
  final double? spaceBetween;
  final Color? checkColor;
  final Color borderColor;
  final Color linkedTextColor;
  final TextOverflow overflow;
  final bool underline;
  final double? iconSize;
  final String? imagePath;
  final Widget? checkedChild;
  final bool showCheckIcon;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTap,
    this.linkOnTap,
    this.text = '',
    this.linkedText,
    this.textSize,
    this.textWeight,
    this.size,
    this.spaceBetween,
    this.checkColor,
    this.borderColor = const Color(0xFFBCBCBC),
    this.linkedTextColor = const Color(0xFF004DFF),
    this.overflow = TextOverflow.visible,
    this.underline = true,
    this.iconSize,
    this.imagePath,
    this.checkedChild,
    this.showCheckIcon = true,
  });

  const AppCheckbox.label({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.onTap,
    this.textSize,
    this.textWeight,
    this.size,
    this.spaceBetween,
    this.checkColor,
    this.borderColor = const Color(0xFFBCBCBC),
    this.overflow = TextOverflow.visible,
    this.iconSize,
    this.imagePath,
    this.checkedChild,
    this.showCheckIcon = true,
  })  : linkedText = null,
        linkOnTap = null,
        linkedTextColor = const Color(0xFF004DFF),
        underline = true;

  const AppCheckbox.link({
    super.key,
    required this.text,
    required this.linkedText,
    required this.value,
    required this.onChanged,
    this.onTap,
    this.linkOnTap,
    this.textSize,
    this.textWeight,
    this.size,
    this.spaceBetween,
    this.checkColor,
    this.borderColor = const Color(0xFFBCBCBC),
    this.linkedTextColor = const Color(0xFF004DFF),
    this.overflow = TextOverflow.visible,
    this.underline = true,
    this.iconSize,
    this.imagePath,
    this.checkedChild,
    this.showCheckIcon = true,
  });

  Widget? _resolveCheckedChild() {
    if (checkedChild != null) return checkedChild;
    if (imagePath == null) return null;

    return KumeleAssetWidget(
      key: const ValueKey('image'),
      assetPath: imagePath!,
      width: iconSize ?? 14.w,
      height: iconSize ?? 14.w,
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final resolvedCheckedChild = _resolveCheckedChild();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CheckboxBox(
          value: value,
          onChanged: onChanged,
          onTap: onTap,
          size: size,
          checkColor: checkColor,
          borderColor: borderColor,
          iconSize: iconSize,
          checkedChild: resolvedCheckedChild,
          showCheckIcon: showCheckIcon,
        ),
        if (text.isNotEmpty) SizedBox(width: spaceBetween ?? 5.w),
        if (text.isNotEmpty)
          Flexible(
            child: linkedText == null
                ? GestureDetector(
                    onTap: () {
                      onChanged(!value);
                      onTap?.call();
                    },
                    child: Text(
                      text,
                      style: context.textTheme.bodySmall.copyWith(
                        fontSize: textSize ?? (isPortrait ? 12.sp : 15.sp),
                        fontWeight: textWeight ?? FontWeight.w400,
                      ),
                      overflow: overflow,
                    ),
                  )
                : KumeleTextLink(
                    leading: text,
                    trailing: linkedText!,
                    leadingStyle: context.textTheme.bodySmall.copyWith(
                      fontSize: textSize ?? (isPortrait ? 12.sp : 15.sp),
                      fontWeight: textWeight ?? FontWeight.w400,
                    ),
                    trailingStyle: context.textTheme.bodySmall.copyWith(
                      fontSize: textSize ?? (isPortrait ? 12.sp : 15.sp),
                      color: linkedTextColor,
                      fontWeight: FontWeight.w400,
                      decoration: underline ? TextDecoration.underline : null,
                    ),
                    overflow: overflow,
                    onTap: linkOnTap,
                  ),
          ),
      ],
    );
  }
}

class _CheckboxBox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onTap;
  final double? size;
  final Color? checkColor;
  final Color borderColor;
  final double? iconSize;
  final Widget? checkedChild;
  final bool showCheckIcon;

  const _CheckboxBox({
    required this.value,
    required this.onChanged,
    this.onTap,
    this.size,
    this.checkColor,
    required this.borderColor,
    this.iconSize,
    this.checkedChild,
    this.showCheckIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final boxSize = size ?? (isPortrait ? 20.w : 25.w);

    return GestureDetector(
      onTap: () {
        onChanged(!value);
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color:
                value ? checkColor ?? ColorSet.specialBlueColor : borderColor,
            width: 1.5,
          ),
          color: value
              ? checkColor ?? ColorSet.specialBlueColor
              : Colors.transparent,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: value
              ? checkedChild ??
                  (showCheckIcon
                      ? Icon(
                          Icons.check,
                          key: const ValueKey('icon'),
                          size: size != null ? size! * 0.7 : iconSize ?? 14.w,
                          color: ColorSet.bg3Color,
                        )
                      : const SizedBox.shrink(key: ValueKey('checked-empty')))
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ),
    );
  }
}
