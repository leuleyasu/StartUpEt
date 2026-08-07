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

  factory Application.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> combinedData = {};
    if (json['data'] is Map) {
      combinedData.addAll(Map<String, dynamic>.from(json['data'] as Map));
    }
    json.forEach((key, value) {
      if (key != 'data') {
        combinedData[key] = value;
      }
    });

    return Application(
      id: (json['id'] ?? combinedData['id'] ?? '').toString(),
      startupId: (json['startupId'] ?? combinedData['startupId'])?.toString(),
      status: (json['status'] ?? combinedData['status'] ?? 'DRAFT').toString(),
      type: (json['type'] ?? combinedData['type'])?.toString(),
      createdAt: (json['createdAt'] ?? combinedData['createdAt'])?.toString(),
      updatedAt: (json['updatedAt'] ?? combinedData['updatedAt'])?.toString(),
      data: combinedData,
    );
  }

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
