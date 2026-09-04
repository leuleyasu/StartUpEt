import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/report_service.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService _service;

  ReportBloc(this._service) : super(const ReportInitial()) {
    on<FetchHubReports>(_onFetchHubReports);
    on<SubmitStartupReport>(_onSubmitStartupReport);
    on<SubmitHubReportEvent>(_onSubmitHubReport);
  }

  Future<void> _onFetchHubReports(
    FetchHubReports event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoading());
    final result = await _service.getHubReports();
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (reports) => emit(HubReportsLoaded(reports)),
    );
  }

  Future<void> _onSubmitStartupReport(
    SubmitStartupReport event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoading());
    final result = await _service.submitReport(
      reportType: event.reportType,
      notes: event.notes,
      fileIds: event.fileIds,
    );
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (submission) => emit(ReportSubmittedSuccess(submission)),
    );
  }

  Future<void> _onSubmitHubReport(
    SubmitHubReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(const ReportLoading());
    final result = await _service.submitHubReport(
      hubId: event.hubId,
      period: event.period,
      title: event.title,
      description: event.description,
      metrics: event.metrics,
    );
    result.fold(
      (failure) => emit(ReportError(failure.message)),
      (report) => emit(HubReportSubmittedSuccess(report)),
    );
  }
}
