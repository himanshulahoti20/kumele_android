import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/features/profile/presentation/profileset/profile.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    this.image,
    this.size,
    this.iconColor,
    this.bgColor,
    this.onPressed,
    super.key,
  });

  final String? image;
  final double? size;
  final Color? iconColor;
  final Color? bgColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final double finalSize = size ?? 37;
    return ClickWidget(
      onPressed: onPressed ??
          () {
            showDialog(
              barrierColor: ColorSet.bcColor, // Less dark background

              context: context,
              builder: (context) => const Profile(
                thisIsDLG: true,
              ),
            );
          },
      child: CircleAvatar(
        radius: finalSize / 2,
        backgroundColor: bgColor ?? ColorSet.subTextColor,
        child: ClipOval(
          child: Image.network(
            image ?? '',
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return KumeleAssetWidget(
                assetPath: SVGAsset.icon_profile,
                color: iconColor ?? ColorSet.textColor,
                width: finalSize * 0.8,
                height: finalSize * 0.8,
              );
            },
          ),
        ),
      ),
    );
  }
}
