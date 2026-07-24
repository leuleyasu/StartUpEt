class CronResult {
  final String status;
  final String? message;
  final int? processed;

  const CronResult({required this.status, this.message, this.processed});

  factory CronResult.fromJson(Map<String, dynamic> json) => CronResult(
    status: json['status'] as String,
    message: json['message'] as String?,
    processed: json['processed'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    if (message != null) 'message': message,
    if (processed != null) 'processed': processed,
  };
}
