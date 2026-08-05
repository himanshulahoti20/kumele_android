class CreateEventResponseModel {
  const CreateEventResponseModel({required this.eventId});

  final String eventId;

  factory CreateEventResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateEventResponseModel(
      eventId: json['event_id']?.toString() ??
          json['eventId']?.toString() ??
          json['id']?.toString() ??
          '',
    );
  }
}
