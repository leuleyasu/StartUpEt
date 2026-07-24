import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/cron_service.dart';
import 'cron_event.dart';
import 'cron_state.dart';

class CronBloc extends Bloc<CronEvent, CronState> {
  final CronService _service;

  CronBloc(this._service) : super(const CronInitial()) {
    on<CheckExpirations>(_onCheck);
  }

  Future<void> _onCheck(CheckExpirations event, Emitter<CronState> emit) async {
    emit(const CronLoading());
    final r = await _service.checkExpirations();
    r.fold((f) => emit(CronError(f.message)), (d) => emit(CronCompleted(d)));
  }
}
