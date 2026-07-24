class Space {
  final String id;
  final String name;
  final String? description;
  final String? location;
  final int? capacity;
  final List<String>? amenities;
  final String? status;
  final String? createdAt;

  const Space({
    required this.id,
    required this.name,
    this.description,
    this.location,
    this.capacity,
    this.amenities,
    this.status,
    this.createdAt,
  });

  factory Space.fromJson(Map<String, dynamic> json) => Space(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    location: json['location'] as String?,
    capacity: json['capacity'] as int?,
    amenities: (json['amenities'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    status: json['status'] as String?,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (description != null) 'description': description,
    if (location != null) 'location': location,
    if (capacity != null) 'capacity': capacity,
    if (amenities != null) 'amenities': amenities,
    if (status != null) 'status': status,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
