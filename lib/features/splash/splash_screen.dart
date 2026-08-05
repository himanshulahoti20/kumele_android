import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/utils/device_utils.dart';
import 'package:kuemele/shared/utils/storage_util.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkVideoSplashStatus();
  }

  Future<void> _checkVideoSplashStatus() async {
    final videoSplashShown = await StorageUtil.retrieveItem(StorageKey.VIDEO_SPLASH_SHOWN);
    if (videoSplashShown == true && mounted) {
      context.go(AppRoutes.splash2);
    } else {
      _timer = Timer(const Duration(seconds: 11), _navigateToNext);
    }
  }

  void _navigateToNext() {
    if (mounted) {
      StorageUtil.storeItem(StorageKey.VIDEO_SPLASH_SHOWN, true);
      context.go(AppRoutes.splash2);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          KumeleVideoPlayer(
            videoPath: FormFactor.isTablet
                ? Assets.videos.kiv
                : Assets.videos.splashMobile,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 16,
            top: MediaQuery.of(context).viewPadding.top + 16,
            child: KumeleAssetWidget(assetPath: Assets.images.logo.path),
          ),
          Positioned(
            bottom: 100,
            right: 26,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: ColorSet.specialBlueColor,
                  width: 2,
                ),
                minimumSize: const Size(90, 40),
              ),
              onPressed: _navigateToNext,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: ColorSet.specialBlueColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
