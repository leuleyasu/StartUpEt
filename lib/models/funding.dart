class Funding {
  final String id;
  final String title;
  final String? description;
  final double? amount;
  final String? deadline;
  final String? status;
  final String? provider;
  final String? createdAt;

  const Funding({
    required this.id,
    required this.title,
    this.description,
    this.amount,
    this.deadline,
    this.status,
    this.provider,
    this.createdAt,
  });

  factory Funding.fromJson(Map<String, dynamic> json) => Funding(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    deadline: json['deadline'] as String?,
    status: json['status'] as String?,
    provider: json['provider'] as String?,
    createdAt: json['createdAt'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (description != null) 'description': description,
    if (amount != null) 'amount': amount,
    if (deadline != null) 'deadline': deadline,
    if (status != null) 'status': status,
    if (provider != null) 'provider': provider,
    if (createdAt != null) 'createdAt': createdAt,
  };
}
