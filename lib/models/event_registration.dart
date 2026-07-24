class EventRegistration {
  final String id;
  final String? eventId;
  final String? eventTitle;
  final String? name;
  final String? email;
  final String? status;
  final String? registeredAt;

  const EventRegistration({
    required this.id,
    this.eventId,
    this.eventTitle,
    this.name,
    this.email,
    this.status,
    this.registeredAt,
  });

  factory EventRegistration.fromJson(Map<String, dynamic> json) =>
      EventRegistration(
        id: json['id'] as String,
        eventId: json['eventId'] as String?,
        eventTitle: json['eventTitle'] as String?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        status: json['status'] as String?,
        registeredAt: json['registeredAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (eventId != null) 'eventId': eventId,
    if (eventTitle != null) 'eventTitle': eventTitle,
    if (name != null) 'name': name,
    if (email != null) 'email': email,
    if (status != null) 'status': status,
    if (registeredAt != null) 'registeredAt': registeredAt,
  };
}
