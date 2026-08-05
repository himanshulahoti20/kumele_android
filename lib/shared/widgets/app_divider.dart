import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum AppDividerType { horizontal, vertical }

class AppDivider extends StatelessWidget {
  const AppDivider.horizontal({
    super.key,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
  })  : type = AppDividerType.horizontal,
        width = null;

  const AppDivider.vertical({
    super.key,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.width,
  })  : type = AppDividerType.vertical,
        height = null;

  final AppDividerType type;
  final Color? color;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? ColorSet.bgColor;
    final dividerThickness = thickness ?? 1.h;

    if (type == AppDividerType.vertical) {
      return Container(
        width: width ?? dividerThickness,
        margin: EdgeInsets.symmetric(vertical: indent ?? 0),
        color: dividerColor,
      );
    }

    return Divider(
      color: dividerColor,
      height: height ?? dividerThickness,
      thickness: dividerThickness,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
