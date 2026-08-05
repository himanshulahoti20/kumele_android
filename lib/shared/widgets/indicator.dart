import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';

class Indicator extends StatelessWidget {
  final bool hasNew;
  final Widget child;
  final bool hasBorder;
  final Color? borderColor;
  final Color? color;
  final double? right;
  final double? top;
  final double size;
  const Indicator({
    super.key,
    required this.child,
    required this.hasNew,
    this.hasBorder = true,
    this.borderColor,
    this.color,
    this.right,
    this.top,
    this.size = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: child,
        ),
        Visibility(
          visible: hasNew,
          child: Positioned(
            right: right ?? 0,
            top: top ?? 0,
            child: Container(
              width: hasBorder ? (size + 1) : size,
              height: hasBorder ? (size + 1) : size,
              decoration: ShapeDecoration(
                color: color ?? ColorSet.specialYellowColor,
                shape: OvalBorder(
                  side: hasBorder ? BorderSide(color: borderColor ?? ColorSet.bg2Color, width: 1.0) : BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
