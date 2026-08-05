import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/core/theme/app_radius.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AppQrCode extends StatelessWidget {
  const AppQrCode({
    super.key,
    required this.data,
    required this.size,
    this.foregroundColor,
    this.backgroundColor = Colors.white,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
    this.onTap,
    this.semanticLabel,
  });

  final String data;
  final double size;
  final Color? foregroundColor;
  final Color backgroundColor;
  final double? padding;
  final double? borderRadius;
  final bool showBorder;
  final VoidCallback? onTap;
  final String? semanticLabel;

  static Future<void> showBottomSheet({
    required BuildContext context,
    required String data,
    String? title,
    double size = 220,
  }) {
    if (data.isEmpty) return Future.value();

    return AppBottomSheet.show(
      context: context,
      title: title ?? AppStrings.myQrCode,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: AppQrCode(
            data: data,
            size: size,
            padding: 16,
            borderRadius: AppRadius.md,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final frameSize = _scaled(context, size);
    final contentPadding = _scaled(context, padding ?? _paddingForSize(size));
    final radius = _scaled(context, borderRadius ?? _radiusForSize(size));
    final qrSize = frameSize - (contentPadding * 2);
    final fg = foregroundColor ?? ColorSet.textColor;

    final isImage = data.startsWith('data:image/') ||
        data.startsWith('http://') ||
        data.startsWith('https://');

    final qr = Container(
      width: frameSize,
      height: frameSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder ? Border.all(color: ColorSet.border) : null,
      ),
      padding: EdgeInsets.all(contentPadding),
      child: isImage
          ? KumeleAssetWidget(
              assetPath: data,
              width: qrSize,
              height: qrSize,
              fit: BoxFit.contain,
            )
          : QrImageView(
              data: data,
              version: QrVersions.auto,
              size: qrSize,
              backgroundColor: backgroundColor,
              gapless: true,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.circle,
                color: fg,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: fg,
              ),
            ),
    );

    if (onTap == null) return qr;

    return Semantics(
      label: semanticLabel ?? AppStrings.myQrCode,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: qr,
      ),
    );
  }

  double _scaled(BuildContext context, double value) {
    return context.responsiveOrNull?.w(value) ?? value;
  }

  static double _paddingForSize(double size) {
    if (size <= 80) return 6;
    if (size <= 120) return 8;
    return 12;
  }

  static double _radiusForSize(double size) {
    if (size <= 80) return AppRadius.sm;
    return AppRadius.md;
  }
}
