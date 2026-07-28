import 'user.dart';

class AuthResponse {
  final User user;
  final String? token;

  const AuthResponse({required this.user, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    user: User.fromJson(json['user'] as Map<String, dynamic>),
    token: (json['token'] ?? json['apiKey'] ?? json['accessToken']) as String?,
  );

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    if (token != null) 'token': token,
  };
}
