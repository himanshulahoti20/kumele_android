// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageKey {
  static const USER_TOKEN = 'user_token';
  static const USER_REFRESH_TOKEN = 'user_refresh_token';
  static const AUTH_SESSION = 'auth_session';
  static const USER_SOUND_NOTIFICATIONS = 'user_sound_notifications';
  static const USER_EMAIL_NOTIFICATIONS = 'user_email_notifications';
  static const SIGNIN_REMEMBER_ME = 'signin_remember_me';
  static const SIGNIN_REMEMBERED_EMAIL = 'signin_remembered_email';
  static const VIDEO_SPLASH_SHOWN = 'video_splash_shown';
  static const DEVICE_ID = 'device_id';
  static const APP_LOCALE = 'app_locale';
  static const FCM_REGISTRATION = 'fcm_registration';
  static const PERMISSION_PRIMER_SHOWN = 'permission_primer_shown_v2';
}

class StorageUtil {
  static const _boxName = 'kumele_storage';

  static Box<dynamic>? _box;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const Set<String> _sensitiveKeys = {
    StorageKey.USER_TOKEN,
    StorageKey.USER_REFRESH_TOKEN,
    StorageKey.AUTH_SESSION,
  };

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  static Box<dynamic> get _storage {
    final box = _box;
    if (box == null || !box.isOpen) {
      throw StateError('StorageUtil.init() must be called before use.');
    }
    return box;
  }

  /// Store item
  static Future<void> storeItem(String key, dynamic value) async {
    if (_sensitiveKeys.contains(key)) {
      final secureValue = _serializeSensitiveValue(key, value);
      if (secureValue == null) {
        await _secureStorage.delete(key: key);
      } else {
        await _secureStorage.write(key: key, value: secureValue);
      }
      await _storage.delete(key);
      return;
    }
    await _storage.put(key, value);
  }

  /// Store list item
  static Future<void> storeList(String key, List<String> value) async {
    await _storage.put(key, value);
  }

  /// Delete item
  static Future<void> deleteItem(String key) async {
    if (_sensitiveKeys.contains(key)) {
      await _secureStorage.delete(key: key);
      await _storage.delete(key);
      return;
    }
    await _storage.delete(key);
  }

  /// Retrieve item
  static Future<dynamic> retrieveItem(String key) async {
    if (_sensitiveKeys.contains(key)) {
      final secureValue = await _secureStorage.read(key: key);
      if (secureValue != null) {
        return _deserializeSensitiveValue(key, secureValue);
      }

      // One-time migration from the legacy Hive box.
      final legacyValue = _storage.get(key);
      if (legacyValue != null) {
        final migratedValue = _serializeSensitiveValue(key, legacyValue);
        if (migratedValue != null) {
          await _secureStorage.write(key: key, value: migratedValue);
        }
        await _storage.delete(key);
        return legacyValue;
      }
      return null;
    }
    return _storage.get(key);
  }

  /// Retrieve list item
  static Future<List<String>> retrieveListItem(String key) async {
    try {
      final value = _storage.get(key);
      if (value is List) {
        return value.map((item) => item.toString()).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Delete all
  static Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
    await _storage.clear();
  }

  static String? _serializeSensitiveValue(String key, dynamic value) {
    if (value == null) return null;
    return key == StorageKey.AUTH_SESSION
        ? jsonEncode(value)
        : value.toString();
  }

  static dynamic _deserializeSensitiveValue(String key, String value) {
    if (key != StorageKey.AUTH_SESSION) return value;
    try {
      final decoded = jsonDecode(value);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } on FormatException {
      return null;
    }
  }
}
