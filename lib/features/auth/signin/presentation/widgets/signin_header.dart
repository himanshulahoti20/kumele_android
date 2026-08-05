import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class SigninHeader extends StatelessWidget {
  const SigninHeader({
    super.key,
    this.showTitle = true,
  });

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final headerHeight = responsive.screenSize.height *
        (responsive.isTablet
            ? AuthConfig.tabletHeaderHeightFactor
            : AuthConfig.phoneHeaderHeightFactor);

    return Stack(
      children: [
        KumeleAssetWidget(
          assetPath: responsive.isTablet
              ? AuthConfig.tabletBackgroundImage
              : AuthConfig.phoneBackgroundImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: headerHeight,
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.horizontalPadding * 2,
              responsive.verticalPadding,
              0,
              0,
            ),
            child: KumeleAssetWidget(
              assetPath: AuthConfig.logoImage,
            ),
          ),
        ),
        if (showTitle && responsive.isPhone)
          Positioned(
            bottom: 16,
            left: 16,
            child: Row(
              children: [
                Text(
                  AuthConfig.signInLabel,
                  style: context.textTheme.heading2.copyWith(
                    color: ColorSet.textColor,
                  ),
                ),
                const Gap(10),
                const AuthGoogleSignInButton(),
              ],
            ),
          ),
      ],
    );
  }
}
