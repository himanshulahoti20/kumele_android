import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class GuidelinePlaceholder extends StatelessWidget {
  const GuidelinePlaceholder({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.textTheme.bodySmall.copyWith(fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
