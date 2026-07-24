class StartupStatus {
  final String id;
  final String name;
  final String status;
  final String? membershipExpiresAt;
  final String? sector;
  final String? stage;
  final String? description;

  const StartupStatus({
    required this.id,
    required this.name,
    required this.status,
    this.membershipExpiresAt,
    this.sector,
    this.stage,
    this.description,
  });

  factory StartupStatus.fromJson(Map<String, dynamic> json) => StartupStatus(
    id: json['id'] as String,
    name: json['name'] as String,
    status: json['status'] as String,
    membershipExpiresAt: json['membershipExpiresAt'] as String?,
    sector: json['sector'] as String?,
    stage: json['stage'] as String?,
    description: json['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    if (membershipExpiresAt != null) 'membershipExpiresAt': membershipExpiresAt,
    if (sector != null) 'sector': sector,
    if (stage != null) 'stage': stage,
    if (description != null) 'description': description,
  };
}
