import 'package:equatable/equatable.dart';

import '../../../models/application.dart';

abstract class ApplicationState extends Equatable {
  const ApplicationState();

  @override
  List<Object?> get props => [];
}

class ApplicationInitial extends ApplicationState {
  const ApplicationInitial();
}

class ApplicationLoading extends ApplicationState {
  const ApplicationLoading();
}

class ApplicationListLoaded extends ApplicationState {
  final List<Application> applications;
  const ApplicationListLoaded(this.applications);
  @override
  List<Object?> get props => [applications];
}

class ApplicationDetailLoaded extends ApplicationState {
  final Application application;
  const ApplicationDetailLoaded(this.application);
  @override
  List<Object?> get props => [application];
}

class ApplicationCreated extends ApplicationState {
  final Application application;
  const ApplicationCreated(this.application);
  @override
  List<Object?> get props => [application];
}

class ApplicationError extends ApplicationState {
  final String message;
  const ApplicationError(this.message);
  @override
  List<Object?> get props => [message];
}
