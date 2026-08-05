import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';

class HobbyInterestModel {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String? icon;
  final bool isActive;

  const HobbyInterestModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.isActive,
    this.icon,
  });

  factory HobbyInterestModel.fromJson(Map<String, dynamic> json) {
    return HobbyInterestModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  HobbyInterest toEntity() {
    return HobbyInterest(
      id: id,
      categoryId: categoryId,
      name: name,
      slug: slug,
      icon: icon,
    );
  }
}
