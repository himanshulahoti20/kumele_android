import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum ImagePickerSource {
  gallery,
  camera,
}

class PickedImage {
  const PickedImage({
    required this.path,
    this.name,
  });

  final String path;
  final String? name;
}

sealed class AppImagePickerException implements Exception {
  const AppImagePickerException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class ImagePickerPlatformUnsupportedException
    extends AppImagePickerException {
  const ImagePickerPlatformUnsupportedException()
      : super('Image picking is only supported on Android.');
}

final class ImagePickerPermissionDeniedException
    extends AppImagePickerException {
  const ImagePickerPermissionDeniedException(String source)
      : super('$source permission is required to select an image.');
}

final class ImagePickerPermissionPermanentlyDeniedException
    extends AppImagePickerException {
  const ImagePickerPermissionPermanentlyDeniedException(String source)
      : super(
          '$source permission is permanently denied. Please allow it in settings.',
        );
}

final class ImagePickerFailureException extends AppImagePickerException {
  const ImagePickerFailureException([super.message = 'Failed to pick image.']);
}

class ImagePickerService {
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  bool get isSupported => Platform.isAndroid;

  Future<PickedImage?> pickImage(ImagePickerSource source) async {
    if (!isSupported) {
      throw const ImagePickerPlatformUnsupportedException();
    }

    await _ensurePermission(source);

    try {
      final file = await _picker.pickImage(
        source: source == ImagePickerSource.gallery
            ? ImageSource.gallery
            : ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (file == null) return null;

      return PickedImage(path: file.path, name: file.name);
    } on AppImagePickerException {
      rethrow;
    } on Exception {
      throw const ImagePickerFailureException();
    }
  }

  Future<void> _ensurePermission(ImagePickerSource source) async {
    switch (source) {
      case ImagePickerSource.camera:
        return _requestPermission(Permission.camera, 'Camera');
      case ImagePickerSource.gallery:
        return _requestGalleryPermission();
    }
  }

  Future<void> _requestGalleryPermission() async {
    try {
      await _requestPermission(Permission.photos, 'Gallery');
    } on ImagePickerPermissionDeniedException {
      await _requestPermission(Permission.storage, 'Gallery');
    }
  }

  Future<void> _requestPermission(
    Permission permission,
    String permissionName,
  ) async {
    var status = await permission.status;
    if (status.isGranted || status.isLimited) return;

    status = await permission.request();
    if (status.isGranted || status.isLimited) return;

    if (status.isPermanentlyDenied) {
      throw ImagePickerPermissionPermanentlyDeniedException(permissionName);
    }

    throw ImagePickerPermissionDeniedException(permissionName);
  }
}
