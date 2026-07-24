import 'package:equatable/equatable.dart';

abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();

  @override
  List<Object?> get props => [];
}

class FetchApplications extends ApplicationEvent {
  const FetchApplications();
}

class FetchApplicationDetail extends ApplicationEvent {
  final String id;

  const FetchApplicationDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateApplication extends ApplicationEvent {
  final Map<String, dynamic> data;

  const CreateApplication(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateApplication extends ApplicationEvent {
  final Map<String, dynamic> data;

  const UpdateApplication(this.data);

  @override
  List<Object?> get props => [data];
}
