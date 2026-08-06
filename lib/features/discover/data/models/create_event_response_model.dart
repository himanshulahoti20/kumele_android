class CreateEventResponseModel {
  const CreateEventResponseModel({
    required this.eventId,
    this.creationPlan = const {},
  });

  final String eventId;
  final Map<String, dynamic> creationPlan;

  factory CreateEventResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateEventResponseModel(
      eventId: json['event_id']?.toString() ??
          json['eventId']?.toString() ??
          json['id']?.toString() ??
          '',
      creationPlan: json['creationPlan'] is Map
          ? Map<String, dynamic>.from(json['creationPlan'] as Map)
          : json['creation_plan'] is Map
              ? Map<String, dynamic>.from(json['creation_plan'] as Map)
              : const {},
    );
  }

  factory CreateEventResponseModel.fromResponse(dynamic response) {
    final root = response is Map ? Map<String, dynamic>.from(response) : {};
    final data = root['data'] is Map
        ? Map<String, dynamic>.from(root['data'] as Map)
        : root;
    return CreateEventResponseModel.fromJson({
      ...data,
      if (root['creationPlan'] != null) 'creationPlan': root['creationPlan'],
      if (root['creation_plan'] != null) 'creation_plan': root['creation_plan'],
    });
  }

  bool get requiresPayment {
    return creationPlan['requiresPayment'] == true ||
        creationPlan['requires_payment'] == true ||
        creationPlan['amount'] != null ||
        creationPlan['amountEur'] != null ||
        creationPlan['amount_eur'] != null;
  }
}
