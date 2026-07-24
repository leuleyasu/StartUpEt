class EcosystemApplication {
  final String id;
  final String? startupId;
  final String status;
  final String? type;
  final String? createdAt;
  final Map<String, dynamic>? data;

  const EcosystemApplication({
    required this.id,
    this.startupId,
    required this.status,
    this.type,
    this.createdAt,
    this.data,
  });

  factory EcosystemApplication.fromJson(Map<String, dynamic> json) =>
      EcosystemApplication(
        id: json['id'] as String,
        startupId: json['startupId'] as String?,
        status: json['status'] as String,
        type: json['type'] as String?,
        createdAt: json['createdAt'] as String?,
        data: json['data'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (startupId != null) 'startupId': startupId,
    'status': status,
    if (type != null) 'type': type,
    if (createdAt != null) 'createdAt': createdAt,
    if (data != null) 'data': data,
  };
}
