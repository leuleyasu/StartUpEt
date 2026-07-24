class FundingApplication {
  final String id;
  final String? fundingId;
  final String? startupId;
  final String? status;
  final String? appliedAt;
  final Map<String, dynamic>? data;

  const FundingApplication({
    required this.id,
    this.fundingId,
    this.startupId,
    this.status,
    this.appliedAt,
    this.data,
  });

  factory FundingApplication.fromJson(Map<String, dynamic> json) =>
      FundingApplication(
        id: json['id'] as String,
        fundingId: json['fundingId'] as String?,
        startupId: json['startupId'] as String?,
        status: json['status'] as String?,
        appliedAt: json['appliedAt'] as String?,
        data: json['data'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (fundingId != null) 'fundingId': fundingId,
    if (startupId != null) 'startupId': startupId,
    if (status != null) 'status': status,
    if (appliedAt != null) 'appliedAt': appliedAt,
    if (data != null) 'data': data,
  };
}
