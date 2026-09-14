import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/navigation/onboarding_navigation.dart';
import 'package:kuemele/shared/utils/utils.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/l10n/app_localizations.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  SplashScreen2State createState() => SplashScreen2State();
}

class SplashScreen2State extends State<SplashScreen2> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), _navigateToNext);
  }

  Future<void> _navigateToNext() async {
    if (!mounted) return;
    await OnboardingNavigation.navigateAfterAuthentication(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          KumeleAssetWidget(
            assetPath: Assets.images.ss3.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: KumeleAssetWidget(
                      assetPath: Assets.images.logo.path,
                      color: '#004DFF'.toColor(),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kumele',
                          style: context.textTheme.displayLargeBold.copyWith(
                            color: Colors.white,
                            fontSize: context.responsive.isTablet ? 105.54 : 70,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.hobbyMeetupTagline,
                          style:
                              context.textTheme.headlineSmallSemiBold.copyWith(
                            color: '#004DFF'.toColor(),
                            fontSize: context.responsive.isTablet ? 36 : 24,
                          ),
                        ),
                        Gap(8),
                        Text(
                          AppLocalizations.of(context)!.splashTagline,
                          style: context.textTheme.titleMedium.copyWith(
                            color: '#004DFF'.toColor(),
                            fontSize: context.responsive.isTablet ? 21 : 14,
                          ),
                        ),
                        Gap(50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
