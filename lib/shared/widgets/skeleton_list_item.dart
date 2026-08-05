import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: child,
    );
  }
}
