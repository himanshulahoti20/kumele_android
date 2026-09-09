class HobbyInterest {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final String? iconDark;
  final String categoryId;
  final String? color;

  const HobbyInterest({
    required this.id,
    required this.name,
    required this.slug,
    required this.categoryId,
    this.icon,
    this.iconDark,
    this.color,
  });
}
