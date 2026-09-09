import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';

class HobbyInterestModel {
  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final String? icon;
  final String? iconDark;
  final bool isActive;

  const HobbyInterestModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.isActive,
    this.icon,
    this.iconDark,
  });

  factory HobbyInterestModel.fromJson(Map<String, dynamic> json) {
    return HobbyInterestModel(
      id: json['id']?.toString() ?? '',
      categoryId: (json['categoryId'] ?? json['category_id'])?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      icon: json['icon']?.toString(),
      iconDark: (json['iconDark'] ?? json['icon_dark'])?.toString(),
      isActive: (json['isActive'] ?? json['is_active']) as bool? ?? true,
    );
  }

  HobbyInterest toEntity() {
    return HobbyInterest(
      id: id,
      categoryId: categoryId,
      name: name,
      slug: slug,
      icon: icon,
      iconDark: iconDark,
    );
  }
}
