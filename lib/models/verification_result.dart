class VerificationResult {
  final bool verified;
  final String? message;
  final Map<String, dynamic>? data;

  const VerificationResult({required this.verified, this.message, this.data});

  factory VerificationResult.fromJson(Map<String, dynamic> json) =>
      VerificationResult(
        verified: json['verified'] as bool? ?? false,
        message: json['message'] as String?,
        data: json['data'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'verified': verified,
    if (message != null) 'message': message,
    if (data != null) 'data': data,
  };
}
