class Application {
  final String id;
  final String? startupId;
  final String status;
  final String? type;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? data;

  const Application({
    required this.id,
    this.startupId,
    required this.status,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    id: json['id'] as String,
    startupId: json['startupId'] as String?,
    status: json['status'] as String,
    type: json['type'] as String?,
    createdAt: json['createdAt'] as String?,
    updatedAt: json['updatedAt'] as String?,
    data: json['data'] as Map<String, dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (startupId != null) 'startupId': startupId,
    'status': status,
    if (type != null) 'type': type,
    if (createdAt != null) 'createdAt': createdAt,
    if (updatedAt != null) 'updatedAt': updatedAt,
    if (data != null) 'data': data,
  };
}
