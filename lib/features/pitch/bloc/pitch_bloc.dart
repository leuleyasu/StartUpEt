import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/pitch_service.dart';
import 'pitch_event.dart';
import 'pitch_state.dart';

class PitchBloc extends Bloc<PitchEvent, PitchState> {
  final PitchService _service;

  PitchBloc(this._service) : super(const PitchInitial()) {
    on<CreatePitch>(_onCreate);
  }

  Future<void> _onCreate(CreatePitch event, Emitter<PitchState> emit) async {
    emit(const PitchLoading());
    final r = await _service.createPitch(event.data);
    r.fold((f) => emit(PitchError(f.message)), (d) => emit(PitchCreated(d)));
  }
}
