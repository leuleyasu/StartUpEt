import 'package:equatable/equatable.dart';

import '../../../models/cron_result.dart';

abstract class CronState extends Equatable {
  const CronState();

  @override
  List<Object?> get props => [];
}

class CronInitial extends CronState {
  const CronInitial();
}

class CronLoading extends CronState {
  const CronLoading();
}

class CronCompleted extends CronState {
  final CronResult result;
  const CronCompleted(this.result);
  @override
  List<Object?> get props => [result];
}

class CronError extends CronState {
  final String message;
  const CronError(this.message);
  @override
  List<Object?> get props => [message];
}
