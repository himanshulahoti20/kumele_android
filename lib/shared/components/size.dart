import 'dart:ui' as ui;

import 'package:flutter/material.dart';

double size(double size) => size;

double sizeW(double size) => size;

class FinalSize {
  static double width(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width;
  }

  static double height(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return height;
  }
}

bool isDark() {
  Brightness platformBrightness = ui.window.platformBrightness;
  return platformBrightness == Brightness.dark;
}

extension StringExtension on String {
  String capitalize() {
    var text = trim();
    if (text.isEmpty) {
      return this;
    }

    final List<String> words = text.split(' ');
    String returnText = words.map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }
      return '';
    }).join(' ');

    return returnText.trim();
  }
}
