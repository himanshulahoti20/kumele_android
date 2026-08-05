class CreateEventRequestModel {
  const CreateEventRequestModel({
    required this.title,
    required this.description,
    required this.hobbyCategoryId,
    required this.eventStartTime,
    required this.eventEndTime,
    required this.capacity,
    required this.isPaid,
    required this.basePriceEur,
    required this.latitude,
    required this.longitude,
    required this.displayAddress,
    this.coverImage,
  });

  final String title;
  final String description;
  final String hobbyCategoryId;
  final String eventStartTime;
  final String eventEndTime;
  final int capacity;
  final bool isPaid;
  final num basePriceEur;
  final double latitude;
  final double longitude;
  final String displayAddress;
  final String? coverImage;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'hobbyCategoryId': hobbyCategoryId,
      'eventStartTime': eventStartTime,
      'eventEndTime': eventEndTime,
      'capacity': capacity,
      'isPaid': isPaid,
      'basePriceEur': basePriceEur,
      'latitude': latitude,
      'longitude': longitude,
      'displayAddress': displayAddress,
      if (coverImage != null && coverImage!.isNotEmpty)
        'coverImage': coverImage,
    };
  }
}
