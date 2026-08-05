enum EventTimeType {
  hours_24,
  hours_48,
  days_7;

  String get label => switch (this) {
        hours_24 => '24 Hours',
        hours_48 => '48 Hours',
        days_7 => '7 Days',
      };
}

class CreateMatch {
  final String title;
  final double fee;
  final String time;
  final int guests;
  final String startsIn;
  final String description;
  final String profile;
  final int followers;
  final double rating;
  final CreateMedal medal;
  final CreateModelType type;

  CreateMatch({
    required this.title,
    required this.fee,
    required this.time,
    required this.guests,
    required this.startsIn,
    required this.description,
    required this.profile,
    required this.followers,
    required this.rating,
    required this.medal,
    required this.type,
  });
}

class CreateMedal {
  final String icon;
  final String medalName;
  final String name;
  final String position;
  final String command;
  final double rating;

  CreateMedal({
    required this.icon,
    required this.medalName,
    required this.name,
    required this.position,
    required this.command,
    required this.rating,
  });
}

class CreateModelType {
  final String type;
  final String image;

  CreateModelType({required this.type, required this.image});
}
