enum ReportType {
  startupProgress('STARTUP_PROGRESS'),
  incubationProgress('INCUBATION_PROGRESS'),
  ecosystemAnnual('ECOSYSTEM_ANNUAL');

  final String value;
  const ReportType(this.value);

  static ReportType fromString(String val) {
    return ReportType.values.firstWhere(
      (e) => e.value.toUpperCase() == val.toUpperCase(),
      orElse: () => ReportType.startupProgress,
    );
  }
}

class ReportSubmissionResult {
  final bool success;
  final String? reportId;
  final String? message;

  const ReportSubmissionResult({
    required this.success,
    this.reportId,
    this.message,
  });

  factory ReportSubmissionResult.fromJson(Map<String, dynamic> json) =>
      ReportSubmissionResult(
        success: json['success'] == true,
        reportId: (json['reportId'] ?? json['id'])?.toString(),
        message: json['message']?.toString(),
      );
}

class HubReport {
  final String id;
  final String? hubId;
  final String? period;
  final String? title;
  final String? description;
  final String? status;
  final Map<String, dynamic>? metrics;
  final String? createdAt;

  const HubReport({
    required this.id,
    this.hubId,
    this.period,
    this.title,
    this.description,
    this.status,
    this.metrics,
    this.createdAt,
  });

  factory HubReport.fromJson(Map<String, dynamic> json) => HubReport(
        id: (json['id'] ?? '').toString(),
        hubId: json['hubId']?.toString(),
        period: json['period']?.toString(),
        title: json['title']?.toString(),
        description: json['description']?.toString(),
        status: json['status']?.toString(),
        metrics: json['metrics'] is Map<String, dynamic>
            ? json['metrics'] as Map<String, dynamic>
            : null,
        createdAt: json['createdAt']?.toString(),
      );
}
