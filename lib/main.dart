import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kuemele/app/my_root_app.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/shared/controllers/mynavController.dart';
import 'package:kuemele/shared/services/api_service/api_config.dart';
import 'package:kuemele/shared/services/notification_service.dart';
import 'package:kuemele/shared/services/payment/google_play_billing_service.dart';
import 'package:kuemele/shared/utils/storage_util.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiConfig.validate();
  if (ApiConfig.stripePublishableKey.isNotEmpty) {
    Stripe.publishableKey = ApiConfig.stripePublishableKey;
    Stripe.merchantIdentifier = ApiConfig.stripeMerchantIdentifier;
    await Stripe.instance.applySettings();
  }
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await StorageUtil.init();
  setupServiceLocator();
  GooglePlayBillingService.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put(MyNavController());
  runApp(const MyRootApp());
}
