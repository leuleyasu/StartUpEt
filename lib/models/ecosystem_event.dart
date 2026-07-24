class EcosystemEvent {
  final String id;
  final String title;
  final String? description;
  final String? date;
  final String? location;
  final int? capacity;
  final int? registeredCount;
  final String? status;
  final String? createdAt;

  const EcosystemEvent({
    required this.id,
    required this.title,
    this.description,
    this.date,
    this.location,
    this.capacity,
    this.registeredCount,
    this.status,
    this.createdAt,
  });

  factory EcosystemEvent.fromJson(Map<String, dynamic> json) => EcosystemEvent(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    date: json['date'] as String?,
    location: json['location'] as String?,
    capacity: json['capacity'] as int?,
    registeredCount: json['registeredCount'] as int?,
    status: json['status'] as String?,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (description != null) 'description': description,
    if (date != null) 'date': date,
    if (location != null) 'location': location,
    if (capacity != null) 'capacity': capacity,
    if (registeredCount != null) 'registeredCount': registeredCount,
    if (status != null) 'status': status,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
