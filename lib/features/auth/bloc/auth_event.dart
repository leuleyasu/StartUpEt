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
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
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
