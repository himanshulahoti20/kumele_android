import 'package:geolocator/geolocator.dart';
import 'package:kuemele/shared/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<void> requestPermissions() async {
    await NotificationService.requestPermission();
    await Permission.photos.request();

    final locationStatus = await Permission.location.request();
    if (locationStatus.isGranted &&
        !await Geolocator.isLocationServiceEnabled()) {
      return;
    }
  }
}
