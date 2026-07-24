class NotificationInfo {
  final String id;
  final String? message;
  final String? type;
  final bool? read;
  final String? createdAt;

  const NotificationInfo({
    required this.id,
    this.message,
    this.type,
    this.read,
    this.createdAt,
  });

  factory NotificationInfo.fromJson(Map<String, dynamic> json) =>
      NotificationInfo(
        id: json['id'] as String,
        message: json['message'] as String?,
        type: json['type'] as String?,
        read: json['read'] as bool?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (message != null) 'message': message,
    if (type != null) 'type': type,
    if (read != null) 'read': read,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
