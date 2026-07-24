class Certificate {
  final String id;
  final String? startupId;
  final String? url;
  final String? issuedAt;
  final String? expiresAt;
  final String? status;

  const Certificate({
    required this.id,
    this.startupId,
    this.url,
    this.issuedAt,
    this.expiresAt,
    this.status,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    id: json['id'] as String,
    startupId: json['startupId'] as String?,
    url: json['url'] as String?,
    issuedAt: json['issuedAt'] as String?,
    expiresAt: json['expiresAt'] as String?,
    status: json['status'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (startupId != null) 'startupId': startupId,
    if (url != null) 'url': url,
    if (issuedAt != null) 'issuedAt': issuedAt,
    if (expiresAt != null) 'expiresAt': expiresAt,
    if (status != null) 'status': status,
  };
}
