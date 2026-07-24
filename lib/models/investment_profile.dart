class InvestmentProfile {
  final String id;
  final String? startupId;
  final String? businessPlan;
  final double? requestedAmount;
  final String? sector;
  final String? stage;
  final String? status;

  const InvestmentProfile({
    required this.id,
    this.startupId,
    this.businessPlan,
    this.requestedAmount,
    this.sector,
    this.stage,
    this.status,
  });

  factory InvestmentProfile.fromJson(Map<String, dynamic> json) =>
      InvestmentProfile(
        id: json['id'] as String,
        startupId: json['startupId'] as String?,
        businessPlan: json['businessPlan'] as String?,
        requestedAmount: (json['requestedAmount'] as num?)?.toDouble(),
        sector: json['sector'] as String?,
        stage: json['stage'] as String?,
        status: json['status'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    if (startupId != null) 'startupId': startupId,
    if (businessPlan != null) 'businessPlan': businessPlan,
    if (requestedAmount != null) 'requestedAmount': requestedAmount,
    if (sector != null) 'sector': sector,
    if (stage != null) 'stage': stage,
    if (status != null) 'status': status,
  };
}
