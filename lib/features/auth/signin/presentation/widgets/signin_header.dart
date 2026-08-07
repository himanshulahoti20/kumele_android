import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/app/cubit/locale_cubit.dart';
import 'package:kuemele/features/auth/auth.dart';
import 'package:kuemele/features/auth/config/auth_config.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/core/service_locator.dart';

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
        Positioned(
          top: 16,
          right: 16,
          child: _LanguageSelector(),
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

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      bloc: getIt<LocaleCubit>(),
      builder: (context, state) {
        final currentLanguage = state.languages
            .firstWhere(
              (lang) => lang.code == state.locale.languageCode,
              orElse: () => LanguageModel(code: 'en', name: 'English'),
            );

        return PopupMenuButton<String>(
          onSelected: (code) => getIt<LocaleCubit>().setLocale(code),
          itemBuilder: (BuildContext context) {
            return state.languages
                .map((lang) => PopupMenuItem<String>(
                      value: lang.code,
                      child: Text(lang.name),
                    ))
                .toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 18),
                const Gap(6),
                Text(
                  currentLanguage.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
