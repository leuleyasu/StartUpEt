import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_client.dart';
import '../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  final ApiClient _apiClient;

  AuthBloc(this._authService, this._apiClient) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginWithFayda>(_onLoginWithFayda);
    on<AuthSetApiKey>(_onSetApiKey);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authService.getProtected();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLoginWithFayda(
    AuthLoginWithFayda event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authService.loginWithFayda(event.authCode);
    result.fold(
      (failure) {
        debugPrint("Erorr:  ${failure.message}");
        emit(AuthError(failure.message));
      },
      (response) => emit(AuthAuthenticated(response.user)),
    );
  }

  Future<void> _onSetApiKey(
    AuthSetApiKey event,
    Emitter<AuthState> emit,
  ) async {
    await _apiClient.setApiKey(event.apiKey);
    add(const AuthCheckRequested());
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    await _apiClient.clearApiKey();
    emit(const AuthUnauthenticated());
  }
}
