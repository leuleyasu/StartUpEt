class Pitch {
  final String id;
  final String? investorId;
  final String? subject;
  final String? message;
  final String? title;
  final String? description;
  final double? amount;
  final String? status;
  final List<String>? attachments;
  final String? createdAt;

  const Pitch({
    required this.id,
    this.investorId,
    this.subject,
    this.message,
    this.title,
    this.description,
    this.amount,
    this.status,
    this.attachments,
    this.createdAt,
  });

  factory Pitch.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return Pitch(
      id: (data['id'] ?? data['_id'] ?? json['id'] ?? '').toString(),
      investorId: (data['investorId'] ?? json['investorId'])?.toString(),
      subject: (data['subject'] ??
              data['title'] ??
              json['subject'] ??
              json['title'])
          ?.toString(),
      message: (data['message'] ??
              data['description'] ??
              json['message'] ??
              json['description'])
          ?.toString(),
      title: (data['title'] ??
              data['subject'] ??
              json['title'] ??
              json['subject'])
          ?.toString(),
      description: (data['description'] ??
              data['message'] ??
              json['description'] ??
              json['message'])
          ?.toString(),
      amount: ((data['amount'] ?? json['amount']) as num?)?.toDouble(),
      status: (data['status'] ?? json['status'])?.toString(),
      attachments: (data['attachments'] ?? json['attachments']) is List
          ? ((data['attachments'] ?? json['attachments']) as List)
              .map((e) => e.toString())
              .toList()
          : null,
      createdAt: (data['createdAt'] ?? json['createdAt'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (investorId != null) 'investorId': investorId,
    if (subject != null) 'subject': subject,
    if (message != null) 'message': message,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (amount != null) 'amount': amount,
    if (status != null) 'status': status,
    if (attachments != null) 'attachments': attachments,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
