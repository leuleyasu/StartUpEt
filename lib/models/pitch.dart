class Pitch {
  final String id;
  final String title;
  final String? description;
  final double? amount;
  final String? status;
  final String? createdAt;

  const Pitch({
    required this.id,
    required this.title,
    this.description,
    this.amount,
    this.status,
    this.createdAt,
  });

  factory Pitch.fromJson(Map<String, dynamic> json) => Pitch(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    status: json['status'] as String?,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (description != null) 'description': description,
    if (amount != null) 'amount': amount,
    if (status != null) 'status': status,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
