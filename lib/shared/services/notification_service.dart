import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/domain/repositories/notification_repository.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/services/api_service/api_service.dart';
import 'package:kuemele/shared/utils/init_log.dart';
import 'package:kuemele/shared/utils/storage_util.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class NotificationService {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();
  static AuthorizationStatus? authorizationStatus;
  static bool isOpeningSetting = false;
  static bool _isInitialized = false;
  static bool _listenersRegistered = false;

  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    playSound: true,
  );

  static bool get hasPermission =>
      authorizationStatus == AuthorizationStatus.authorized ||
      authorizationStatus == AuthorizationStatus.provisional;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      await checkPermission();
      InitLog.write('permission=$authorizationStatus', tag: 'FCM');

      if (authorizationStatus == AuthorizationStatus.notDetermined) {
        await requestPermission();
      } else if (hasPermission) {
        await setupNotification();
        await sendFirebaseTokenToBackend();
      }

      _firebaseMessaging.onTokenRefresh.listen(sendFirebaseTokenToBackend);
      _isInitialized = true;
      InitLog.write('initialized', tag: 'FCM');
    } catch (e) {
      InitLog.write('init failed: $e', tag: 'FCM');
    }
  }

  static Future<void> checkPermission() async {
    final res = await _firebaseMessaging.getNotificationSettings();
    authorizationStatus = res.authorizationStatus;
  }

  static Future<void> requestPermission() async {
    final res = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    authorizationStatus = res.authorizationStatus;
    if (!hasPermission) {
      InitLog.write('permission denied', tag: 'FCM');
      return;
    }

    await setupNotification();
    await sendFirebaseTokenToBackend();
    InjectionHelper.profileCubit.updateUserNotification(
      soundNotifications: true,
      emailNotifications: true,
    );
  }

  static Future<void> setupNotification() async {
    if (!hasPermission) return;
    setupPushNotification();
    await setupLocalNotification();
    InitLog.write('listeners ready', tag: 'FCM');
  }

  static void askPermission() {
    final alreadyAsked =
        authorizationStatus != AuthorizationStatus.notDetermined;
    requestPermission().whenComplete(() {
      if (alreadyAsked && !hasPermission) {
        isOpeningSetting = true;
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
    });
  }

  static void setupPushNotification() {
    if (_listenersRegistered) return;
    _listenersRegistered = true;

    _firebaseMessaging.getInitialMessage().then(handleNavigateWhenAppClose);
    FirebaseMessaging.onMessageOpenedApp.listen(handleClickOnMessage);
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_notification',
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification_sound.wav',
        ),
      ),
      payload: message.data.toString(),
    );
  }

  static Future<void> setupLocalNotification() async {
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_notification'),
        iOS: DarwinInitializationSettings(
          defaultPresentSound: true,
          defaultPresentBadge: true,
          defaultPresentAlert: true,
        ),
      ),
      onDidReceiveNotificationResponse: (_) => openMainNotiPage(),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static void handleNavigateWhenAppClose(RemoteMessage? message) {
    if (message == null) return;
    Future.delayed(
      const Duration(milliseconds: 800),
      () => handleClickOnMessage(message),
    );
  }

  static Future<void> handleClickOnMessage(RemoteMessage? message) async {
    if (message == null) return;
    openMainNotiPage();
  }

  static void openMainNotiPage() {
    final context = InjectionHelper.navKey.currentContext;
    if (context == null) return;
    context.push(AppRoutes.notification);
  }

  static Future<String> _deviceId() async {
    final existing = await StorageUtil.retrieveItem(StorageKey.DEVICE_ID);
    if (existing is String && existing.isNotEmpty) return existing;

    final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final id = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    await StorageUtil.storeItem(StorageKey.DEVICE_ID, id);
    return id;
  }

  static String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }

  static Future<void> sendFirebaseTokenToBackend([String? token]) async {
    if (!ApiService.hasToken()) return;

    try {
      final fcmToken = token ?? await _firebaseMessaging.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        InitLog.write('no fcm token', tag: 'FCM');
        return;
      }

      final deviceId = await _deviceId();
      InitLog.write('fcmToken=$fcmToken', tag: 'FCM');
      InitLog.write('deviceId=$deviceId platform=$_platform', tag: 'FCM');

      await getIt<NotificationRepository>().registerPushToken(
        fcmToken: fcmToken,
        platform: _platform,
        deviceId: deviceId,
        language: Platform.localeName.split('_').first,
      );
      InitLog.write('token registered', tag: 'FCM');
    } catch (e) {
      InitLog.write('token register failed: $e', tag: 'FCM');
    }
  }
}
