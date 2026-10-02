class EventRegistration {
  final String id;
  final String? eventId;
  final String? eventTitle;
  final String? name;
  final String? email;
  final String? status;
  final String? registeredAt;
  final String? confirmationCode;

  const EventRegistration({
    required this.id,
    this.eventId,
    this.eventTitle,
    this.name,
    this.email,
    this.status,
    this.registeredAt,
    this.confirmationCode,
  });

  factory EventRegistration.fromJson(Map<String, dynamic> json) {
    // API Reference §3.8: POST /api/events/[id]/register returns
    // { success: true, data: Attendee, confirmationCode: "ETH-<8 chars>" }
    final Map<String, dynamic> data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;
    final code = json['confirmationCode']?.toString() ??
        data['confirmationCode']?.toString();

    return EventRegistration(
      id: (data['id'] ?? json['id'] ?? '').toString(),
      eventId: (data['eventId'] ?? json['eventId'])?.toString(),
      eventTitle:
          (data['eventTitle'] ?? json['eventTitle'] ?? data['title'])?.toString(),
      name: (data['fullName'] ?? data['name'] ?? json['name'])?.toString(),
      email: (data['email'] ?? json['email'])?.toString(),
      status: (data['status'] ?? json['status'])?.toString(),
      registeredAt: (data['registeredAt'] ??
              data['createdAt'] ??
              json['registeredAt'])
          ?.toString(),
      confirmationCode: code,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (eventId != null) 'eventId': eventId,
    if (eventTitle != null) 'eventTitle': eventTitle,
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (status != null) 'status': status,
    if (registeredAt != null) 'registeredAt': registeredAt,
    if (confirmationCode != null) 'confirmationCode': confirmationCode,
  };
}
