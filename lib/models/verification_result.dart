class VerificationResult {
  final bool verified;
  final String? message;
  final Map<String, dynamic>? data;

  const VerificationResult({required this.verified, this.message, this.data});

  factory VerificationResult.fromJson(Map<String, dynamic> json) =>
      VerificationResult(
        verified: json['verified'] == true || json['success'] == true,
        message: (json['message'] ?? json['error'])?.toString(),
        data: json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : (json['data'] is Map
                ? Map<String, dynamic>.from(json['data'] as Map)
                : null),
      );

  Map<String, dynamic> toJson() => {
    'verified': verified,
    if (message != null) 'message': message,
    if (data != null) 'data': data,
  };
}
