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

  factory StartupStatus.fromJson(Map<String, dynamic> json) {
    // Safely unwrap nested response format if present (e.g. { "data": { ... } })
    final data = (json.containsKey('data') && json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return StartupStatus(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      name: (data['name'] ?? data['startupName'] ?? data['title'] ?? 'Startup').toString(),
      status: (data['status'] ?? 'PENDING').toString(),
      membershipExpiresAt:
          data['membershipExpiresAt']?.toString() ?? data['expiresAt']?.toString(),
      sector: data['sector']?.toString() ?? data['industry']?.toString(),
      stage: data['stage']?.toString(),
      description: data['description']?.toString(),
    );
  }

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
