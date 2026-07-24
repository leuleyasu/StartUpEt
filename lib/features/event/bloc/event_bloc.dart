import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/event_service.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventService _service;

  EventBloc(this._service) : super(const EventInitial()) {
    on<FetchEvents>(_onFetchEvents);
    on<FetchEventDetail>(_onFetchDetail);
    on<RegisterForEvent>(_onRegister);
    on<FetchMyRegistrations>(_onFetchRegistrations);
  }

  Future<void> _onFetchEvents(
    FetchEvents event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final r = await _service.getEvents();
    r.fold((f) => emit(EventError(f.message)), (d) => emit(EventsLoaded(d)));
  }

  Future<void> _onFetchDetail(
    FetchEventDetail event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final r = await _service.getEvent(event.id);
    r.fold(
      (f) => emit(EventError(f.message)),
      (d) => emit(EventDetailLoaded(d)),
    );
  }

  Future<void> _onRegister(
    RegisterForEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final r = await _service.registerForEvent(event.id, event.data);
    r.fold((f) => emit(EventError(f.message)), (d) => emit(EventRegistered(d)));
  }

  Future<void> _onFetchRegistrations(
    FetchMyRegistrations event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoading());
    final r = await _service.getMyRegistrations();
    r.fold(
      (f) => emit(EventError(f.message)),
      (d) => emit(EventRegistrationsLoaded(d)),
    );
  }
}
