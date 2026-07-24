import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/startup_service.dart';
import 'startup_event.dart';
import 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final StartupService _service;

  StartupBloc(this._service) : super(const StartupInitial()) {
    on<FetchStartupStatus>(_onFetchStatus);
    on<RenewStartup>(_onRenew);
  }

  Future<void> _onFetchStatus(
    FetchStartupStatus event,
    Emitter<StartupState> emit,
  ) async {
    emit(const StartupLoading());
    final result = await _service.getMyStatus();
    result.fold(
      (failure) => emit(StartupError(failure.message)),
      (data) => emit(StartupLoaded(data)),
    );
  }

  Future<void> _onRenew(RenewStartup event, Emitter<StartupState> emit) async {
    emit(const StartupLoading());
    final result = await _service.renew();
    result.fold(
      (failure) => emit(StartupError(failure.message)),
      (data) => emit(StartupLoaded(data)),
    );
  }
}
