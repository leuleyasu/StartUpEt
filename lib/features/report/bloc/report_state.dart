import 'package:equatable/equatable.dart';
import '../../../models/report.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {
  const ReportInitial();
}

class ReportLoading extends ReportState {
  const ReportLoading();
}

class ReportSubmittedSuccess extends ReportState {
  final ReportSubmissionResult result;

  const ReportSubmittedSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class HubReportsLoaded extends ReportState {
  final List<HubReport> reports;

  const HubReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class HubReportSubmittedSuccess extends ReportState {
  final HubReport report;

  const HubReportSubmittedSuccess(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}
