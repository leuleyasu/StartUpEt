import 'package:equatable/equatable.dart';

import '../../../models/startup_status.dart';

abstract class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object?> get props => [];
}

class StartupInitial extends StartupState {
  const StartupInitial();
}

class StartupLoading extends StartupState {
  const StartupLoading();
}

class StartupLoaded extends StartupState {
  final StartupStatus data;

  const StartupLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class StartupError extends StartupState {
  final String message;

  const StartupError(this.message);

  @override
  List<Object?> get props => [message];
}
