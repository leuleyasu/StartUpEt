import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/verification_service.dart';
import 'verification_event.dart';
import 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final VerificationService _service;

  VerificationBloc(this._service) : super(const VerificationInitial()) {
    on<VerifyNationalId>(_onVerifyNationalId);
    on<VerifyTin>(_onVerifyTin);
  }

  Future<void> _onVerifyNationalId(
    VerifyNationalId event,
    Emitter<VerificationState> emit,
  ) async {
    emit(const VerificationLoading());
    final r = await _service.verifyNationalId(event.nationalId);
    r.fold(
      (f) => emit(VerificationError(f.message)),
      (d) => emit(VerificationResultLoaded(d)),
    );
  }

  Future<void> _onVerifyTin(
    VerifyTin event,
    Emitter<VerificationState> emit,
  ) async {
    emit(const VerificationLoading());
    final r = await _service.verifyTin(event.tin);
    r.fold(
      (f) => emit(VerificationError(f.message)),
      (d) => emit(VerificationResultLoaded(d)),
    );
  }
}
