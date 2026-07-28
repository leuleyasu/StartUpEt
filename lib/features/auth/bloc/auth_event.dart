import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String role;

  const AuthRegisterRequested({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phoneNumber,
        password,
        confirmPassword,
        role,
      ];
}

class AuthLoginWithFayda extends AuthEvent {
  final String authCode;

  const AuthLoginWithFayda(this.authCode);

  @override
  List<Object?> get props => [authCode];
}

class AuthSetApiKey extends AuthEvent {
  final String apiKey;

  const AuthSetApiKey(this.apiKey);

  @override
  List<Object?> get props => [apiKey];
}

class AuthLogout extends AuthEvent {
  const AuthLogout();
}
