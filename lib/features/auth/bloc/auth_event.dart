import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
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
