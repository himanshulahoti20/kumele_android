import 'package:flutter/material.dart';
import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';
import 'package:kuemele/shared/widgets/category_icon_widget.dart';

class HobbyIconWidget extends StatelessWidget {
  final HobbyInterest hobby;
  final double size;
  final Color color;
  final bool showBadge;

  const HobbyIconWidget({
    super.key,
    required this.hobby,
    required this.size,
    required this.color,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryIconWidget(
      icon: hobby.icon,
      size: size,
      color: color,
      badgeColor: showBadge ? hobby.color : null,
    );
  }
}
