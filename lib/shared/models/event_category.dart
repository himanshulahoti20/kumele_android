import 'package:kuemele/shared/models/enums/event_type.dart';

class EventCategory {
  String? id;
  EventType? type;
  String? svgCode;
  String? displayName;

  EventCategory({
    this.id,
    this.type,
    this.svgCode,
    this.displayName,
  });

  String? get name => displayName ?? type?.label;

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String?;

    return EventCategory(
      id: json['id'] as String?,
      type: name?.toEventType(),
      svgCode: json['svg_code'] as String? ?? json['icon'] as String?,
      displayName: name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': displayName ?? type?.label,
      'svg_code': svgCode,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventCategory && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;

  @override
  String toString() => 'EventCategory(id: $id, name: $name)';
}
