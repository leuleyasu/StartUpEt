class UserSessionInfo {
  final String id;
  final String? token;
  final bool isActive;
  final String? userAgent;
  final String? ipAddress;
  final DateTime? createdAt;
  final DateTime? lastActiveAt;
  final bool isCurrentSession;

  const UserSessionInfo({
    required this.id,
    this.token,
    required this.isActive,
    this.userAgent,
    this.ipAddress,
    this.createdAt,
    this.lastActiveAt,
    this.isCurrentSession = false,
  });

  factory UserSessionInfo.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return UserSessionInfo(
      id: (json['id'] ?? json['sessionId'] ?? '') as String,
      token: json['token'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      userAgent: json['userAgent'] as String?,
      ipAddress: json['ipAddress'] as String?,
      createdAt: parseDate(json['createdAt']),
      lastActiveAt: parseDate(json['lastActiveAt']),
      isCurrentSession: json['isCurrent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (token != null) 'token': token,
        'isActive': isActive,
        if (userAgent != null) 'userAgent': userAgent,
        if (ipAddress != null) 'ipAddress': ipAddress,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (lastActiveAt != null) 'lastActiveAt': lastActiveAt!.toIso8601String(),
        'isCurrentSession': isCurrentSession,
      };
}
