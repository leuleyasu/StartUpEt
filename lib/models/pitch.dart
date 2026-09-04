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

  factory Pitch.fromJson(Map<String, dynamic> json) => Pitch(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    investorId: json['investorId']?.toString(),
    subject: (json['subject'] ?? json['title'])?.toString(),
    message: (json['message'] ?? json['description'])?.toString(),
    title: (json['title'] ?? json['subject'])?.toString(),
    description: (json['description'] ?? json['message'])?.toString(),
    amount: (json['amount'] as num?)?.toDouble(),
    status: json['status']?.toString(),
    attachments: json['attachments'] is List
        ? (json['attachments'] as List).map((e) => e.toString()).toList()
        : null,
    createdAt: json['createdAt']?.toString(),
  );

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
