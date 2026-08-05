import 'package:flutter/material.dart';

ImageProvider imageProviderFromPath(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    return NetworkImage(path);
  }

  return AssetImage(path);
}
