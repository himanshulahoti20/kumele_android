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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      isActive: (json['isActive'] ?? json['is_active']) as bool? ?? true,
      sortOrder: _asInt(json['sortOrder'] ?? json['sort_order']),
      icon: json['icon']?.toString(),
      color: json['color']?.toString(),
      hobbies: hobbiesJson
          .whereType<Map>()
          .map((item) =>
              HobbyInterestModel.fromJson(item.cast<String, dynamic>()))
          .toList(),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
