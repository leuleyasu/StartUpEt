class NotificationInfo {
  final String id;
  final String? userId;
  final String? title;
  final String? message;
  final String? type;
  final bool? isRead;
  final String? link;
  final String? createdAt;

  bool get read => isRead ?? false;

  const NotificationInfo({
    required this.id,
    this.userId,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.link,
    this.createdAt,
  });

  factory NotificationInfo.fromJson(Map<String, dynamic> json) =>
      NotificationInfo(
        id: (json['id'] ?? json['_id'] ?? '').toString(),
        userId: json['userId']?.toString(),
        title: json['title']?.toString(),
        message: (json['message'] ?? json['body'])?.toString(),
        type: (json['type'] ?? 'info').toString(),
        isRead: (json['isRead'] ?? json['read']) as bool?,
        link: json['link']?.toString(),
        createdAt: json['createdAt']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (userId != null) 'userId': userId,
    if (title != null) 'title': title,
    if (message != null) 'message': message,
    if (type != null) 'type': type,
    if (isRead != null) 'isRead': isRead,
    if (link != null) 'link': link,
    if (createdAt != null) 'createdAt': createdAt,
  };
}

class SseEvent {
  final String eventType;
  final dynamic data;
  final String? rawData;

  const SseEvent({
    required this.eventType,
    this.data,
    this.rawData,
  });

  bool get isNotification => eventType == 'notification';
  bool get isConnected => eventType == 'connected';
  bool get isHeartbeat => eventType == 'heartbeat';

  NotificationInfo? toNotification() {
    if (data is Map<String, dynamic>) {
      return NotificationInfo.fromJson(data as Map<String, dynamic>);
    }
    return null;
  }
}
