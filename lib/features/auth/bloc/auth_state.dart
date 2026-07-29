import 'package:equatable/equatable.dart';

import '../../../models/user.dart';
import '../../../models/user_session.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRequireVerification extends AuthState {
  final String email;
  final String message;

  const AuthRequireVerification({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];
}

class AuthVerifiedSuccessfully extends AuthState {
  final String message;

  const AuthVerifiedSuccessfully(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthForgotPasswordSuccess extends AuthState {
  final String message;

  const AuthForgotPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSessionsLoaded extends AuthState {
  final List<UserSessionInfo> sessions;

  const AuthSessionsLoaded(this.sessions);

  @override
  List<Object?> get props => [sessions];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
