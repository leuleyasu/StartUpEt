class Booking {
  final String id;
  final String? spaceId;
  final String? startupId;
  final String? date;
  final String? status;
  final String? createdAt;

  const Booking({
    required this.id,
    this.spaceId,
    this.startupId,
    this.date,
    this.status,
    this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    spaceId: json['spaceId'] as String?,
    startupId: json['startupId'] as String?,
    date: json['date'] as String?,
    status: json['status'] as String?,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (spaceId != null) 'spaceId': spaceId,
    if (startupId != null) 'startupId': startupId,
    if (date != null) 'date': date,
    if (status != null) 'status': status,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
