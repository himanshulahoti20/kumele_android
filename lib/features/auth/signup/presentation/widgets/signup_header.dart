import 'package:flutter/material.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({
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
              70,
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
              spacing: 10,
              children: [
                Text(
                  AppLocalizations.of(context)!.signUpButtonLabel,
                  style: context.textTheme.headlineSmallBold.copyWith(
                    color: Colors.black,
                    fontSize: 23,
                  ),
                ),
                const AuthGoogleSignInButton(),
              ],
            ),
          ),
      ],
    );
  }
}
