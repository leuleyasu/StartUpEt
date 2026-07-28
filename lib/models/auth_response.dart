import 'user.dart';

class AuthResponse {
  final User user;
  final String? token;
  final bool requiresVerification;
  final String? message;

  const AuthResponse({
    required this.user,
    this.token,
    this.requiresVerification = false,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final Map<String, dynamic> userMap = userJson is Map<String, dynamic>
        ? userJson
        : json;

    return AuthResponse(
      user: User.fromJson(userMap),
      token: (json['token'] ?? json['apiKey'] ?? json['accessToken'] ?? json['sessionToken']) as String?,
      requiresVerification: json['requiresVerification'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    if (token != null) 'token': token,
    'requiresVerification': requiresVerification,
    if (message != null) 'message': message,
  };
}
