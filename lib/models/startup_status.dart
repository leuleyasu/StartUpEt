class StartupStatus {
  final String id;
  final String name;
  final String status;
  final String? membershipExpiresAt;
  final String? sector;
  final String? stage;
  final String? description;
  final bool hasCertificate;
  final String? level;
  final String? certificateId;
  final int? daysLeft;

  const StartupStatus({
    required this.id,
    required this.name,
    required this.status,
    this.membershipExpiresAt,
    this.sector,
    this.stage,
    this.description,
    this.hasCertificate = false,
    this.level,
    this.certificateId,
    this.daysLeft,
  });

  factory StartupStatus.fromJson(Map<String, dynamic> json) {
    // API Reference §3.5: GET /api/startups/my-status returns
    // { success: true, hasCertificate: bool, startup: { id, level, certificateId, expiresAt, daysLeft, status } }
    final bool hasCert = json['hasCertificate'] == true;
    final Map<String, dynamic> data = (json['startup'] is Map<String, dynamic>)
        ? json['startup'] as Map<String, dynamic>
        : ((json['data'] is Map<String, dynamic>)
            ? json['data'] as Map<String, dynamic>
            : json);

    return StartupStatus(
      id: (data['id'] ?? data['_id'] ?? '').toString(),
      name: (data['name'] ?? data['startupName'] ?? data['title'] ?? 'Startup').toString(),
      status: (data['status'] ?? (hasCert ? 'CERTIFIED' : 'PENDING')).toString(),
      membershipExpiresAt:
          data['membershipExpiresAt']?.toString() ?? data['expiresAt']?.toString(),
      sector: data['sector']?.toString() ?? data['industry']?.toString(),
      stage: data['stage']?.toString(),
      description: data['description']?.toString(),
      hasCertificate: hasCert,
      level: data['level']?.toString(),
      certificateId: data['certificateId']?.toString(),
      daysLeft: data['daysLeft'] is num ? (data['daysLeft'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'hasCertificate': hasCertificate,
    if (membershipExpiresAt != null) 'membershipExpiresAt': membershipExpiresAt,
    if (sector != null) 'sector': sector,
    if (stage != null) 'stage': stage,
    if (description != null) 'description': description,
    if (level != null) 'level': level,
    if (certificateId != null) 'certificateId': certificateId,
    if (daysLeft != null) 'daysLeft': daysLeft,
  };
}
