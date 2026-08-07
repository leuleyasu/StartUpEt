import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/application_service.dart';
import 'application_event.dart';
import 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final ApplicationService _service;

  ApplicationBloc(this._service) : super(const ApplicationInitial()) {
    on<FetchApplications>(_onFetch);
    on<FetchApplicationDetail>(_onFetchDetail);
    on<CreateApplication>(_onCreate);
    on<UpdateApplication>(_onUpdate);
  }

  Future<void> _onFetch(
    FetchApplications event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final r = await _service.getApplications();
    r.fold(
      (f) => emit(ApplicationError(f.message)),
      (d) => emit(ApplicationListLoaded(d)),
    );
  }

  Future<void> _onFetchDetail(
    FetchApplicationDetail event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final r = await _service.getApplication(event.id);
    r.fold(
      (f) => emit(ApplicationError(f.message)),
      (d) => emit(ApplicationDetailLoaded(d)),
    );
  }

  Future<void> _onCreate(
    CreateApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final r = await _service.createApplication(event.data);
    await r.fold(
      (f) async => emit(ApplicationError(f.message)),
      (d) async {
        emit(ApplicationCreated(d));
        final listRes = await _service.getApplications();
        listRes.fold(
          (_) {},
          (apps) => emit(ApplicationListLoaded(apps)),
        );
      },
    );
  }

  Future<void> _onUpdate(
    UpdateApplication event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(const ApplicationLoading());
    final r = await _service.updateApplication(event.data);
    await r.fold(
      (f) async => emit(ApplicationError(f.message)),
      (d) async {
        emit(ApplicationCreated(d));
        final listRes = await _service.getApplications();
        listRes.fold(
          (_) {},
          (apps) => emit(ApplicationListLoaded(apps)),
        );
      },
    );
  }
}
