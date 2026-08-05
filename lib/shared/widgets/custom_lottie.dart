import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class CustomLottie extends StatelessWidget {
  final String file;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CustomLottie(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy theme hiện tại của ứng dụng.
    final brightness = Theme.of(context).brightness;
    // Chọn màu dựa trên theme: trắng cho dark theme, đen cho light theme.
    final newColor = brightness == Brightness.dark ? Colors.white : Colors.black;

    // Sử dụng FutureBuilder để xử lý việc tải và sửa đổi file JSON bất đồng bộ.
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadAndModifyAnimation(newColor),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final updatedData = snapshot.data!;
          return Lottie.memory(
            // json.encode(updatedData),
            Uint8List.fromList(utf8.encode(json.encode(updatedData))),
            width: width,
            height: height,
            fit: fit,
            repeat: true,
            animate: true,
          );
        } else {
          // Trả về một widget placeholder trong khi đang tải.
          return SizedBox(
            width: width ?? 100,
            height: height ?? 100,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  // Phương thức tải và sửa đổi animation.
  Future<Map<String, dynamic>> _loadAndModifyAnimation(Color newColor) async {
    final jsonString = await rootBundle.loadString(file);
    final originalAnimationData = json.decode(jsonString) as Map<String, dynamic>;
    return updateLottieColor(originalAnimationData, newColor);
  }

  Map<String, dynamic> updateLottieColor(Map<String, dynamic> animationData, Color newColor) {
    final updatedData = json.decode(json.encode(animationData));

    final newLottieColor = [
      newColor.red / 255.0,
      newColor.green / 255.0,
      newColor.blue / 255.0,
      newColor.opacity,
    ];

    if (updatedData.containsKey('layers')) {
      final layers = updatedData['layers'] as List;
      for (var layer in layers) {
        if (layer.containsKey('shapes')) {
          final shapes = layer['shapes'] as List;
          for (var shape in shapes) {
            if (shape.containsKey('it')) {
              final items = shape['it'] as List;
              for (var item in items) {
                if (item['ty'] == 'fl' && item.containsKey('c') && item['c'].containsKey('k')) {
                  item['c']['k'] = newLottieColor;
                }
              }
            }
          }
        }
      }
    }
    return updatedData;
  }
}
