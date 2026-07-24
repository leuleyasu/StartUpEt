import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class FetchEvents extends EventEvent {
  const FetchEvents();
}

class FetchEventDetail extends EventEvent {
  final String id;

  const FetchEventDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class RegisterForEvent extends EventEvent {
  final String id;
  final Map<String, dynamic> data;

  const RegisterForEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class FetchMyRegistrations extends EventEvent {
  const FetchMyRegistrations();
}
