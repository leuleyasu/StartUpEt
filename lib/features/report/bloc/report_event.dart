import 'package:equatable/equatable.dart';
import '../../../models/report.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class FetchHubReports extends ReportEvent {
  const FetchHubReports();
}

class SubmitStartupReport extends ReportEvent {
  final ReportType reportType;
  final String? notes;
  final List<String> fileIds;

  const SubmitStartupReport({
    required this.reportType,
    this.notes,
    this.fileIds = const [],
  });

  @override
  List<Object?> get props => [reportType, notes, fileIds];
}

class SubmitHubReportEvent extends ReportEvent {
  final String hubId;
  final String period;
  final String title;
  final String? description;
  final Map<String, dynamic>? metrics;

  const SubmitHubReportEvent({
    required this.hubId,
    required this.period,
    required this.title,
    this.description,
    this.metrics,
  });

  @override
  List<Object?> get props => [hubId, period, title, description, metrics];
}
