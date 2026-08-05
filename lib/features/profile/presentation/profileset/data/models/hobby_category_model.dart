import 'package:kuemele/features/profile/presentation/profileset/data/models/hobby_interest_model.dart';

class HobbyCategoryModel {
  final String id;
  final String name;
  final String slug;
  final bool isActive;
  final int sortOrder;
  final String? icon;
  final String? color;
  final List<HobbyInterestModel> hobbies;

  const HobbyCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.isActive,
    required this.sortOrder,
    required this.hobbies,
    this.icon,
    this.color,
  });

  factory HobbyCategoryModel.fromJson(Map<String, dynamic> json) {
    final hobbiesJson = json['hobbies'] as List<dynamic>? ?? const [];

    return HobbyCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      hobbies: hobbiesJson
          .whereType<Map<String, dynamic>>()
          .map(HobbyInterestModel.fromJson)
          .toList(),
    );
  }
}
