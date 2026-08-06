import 'package:kuemele/shared/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  // Location isn't requested here — LocationCubit (via Geolocator) owns
  // location permission exclusively, requested on the sign-in screen. Asking
  // again through this separate permission_handler API wouldn't update
  // LocationCubit's state, leaving Home stuck showing a stale "location off"
  // view even after this granted it.
  static Future<void> requestPermissions() async {
    await NotificationService.requestPermission();
    // Permission.photos only maps to READ_MEDIA_IMAGES on API 33+ (empty
    // manifest lookup below that, so it silently no-ops pre-Tiramisu).
    // Permission.storage covers the legacy READ_EXTERNAL_STORAGE path the
    // manifest already declares (maxSdkVersion 32) for older devices.
    await [Permission.photos, Permission.storage].request();
  }
}
