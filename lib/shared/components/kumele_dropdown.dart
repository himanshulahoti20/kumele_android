import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/modals/dialog/app_dialog.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class KumeleDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final void Function(String value, int index) onSelected;
  final double? fontSize;
  final double? borderRadius;
  final Color? fillColor;

  const KumeleDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onSelected,
    this.fontSize,
    this.borderRadius,
    this.fillColor,
  });

  @override
  State<KumeleDropdown> createState() => _KumeleDropdownState();
}

class _KumeleDropdownState extends State<KumeleDropdown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.responsive.isTablet;
    final iconSize = isTablet ? 25.0 : 18.0;

    return LayoutBuilder(
      builder: (c, constrain) {
        return ClickWidget(
          onPressed: () {
            setState(() {
              _isOpen = true;
            });
            final width = constrain.maxWidth;
            AppDialog.attach(
              context: c,
              alignment: Alignment.bottomCenter,
              onDismiss: () {
                if (mounted) {
                  setState(() {
                    _isOpen = false;
                  });
                }
              },
              dialog: Container(
                width: width,
                height: isTablet ? 300 : 150,
                padding: EdgeInsets.symmetric(vertical: 7.h),
                decoration: ShapeDecoration(
                  color: ColorSet.bg2Color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 10,
                    children: widget.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final itemValue = entry.value;
                      return ClickWidget(
                        onPressed: () {
                          SmartDialog.dismiss();
                          widget.onSelected(itemValue, index);
                        },
                        child: Center(
                          child: Text(
                            itemValue,
                            style: context.textTheme.bodyLargeSemiBold.copyWith(
                              fontSize: widget.fontSize ?? 18.sp,
                              color: ColorSet.textColor,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 9.r),
              color: widget.fillColor ?? ColorSet.tileFillColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.value,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLargeSemiBold.copyWith(
                      fontSize: widget.fontSize ?? 18.sp,
                      color: ColorSet.textColor,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.75 : 0.25,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: KumeleAssetWidget(
                    assetPath: Assets.svg.iconArrow.path,
                    color: ColorSet.revbg3Color,
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
