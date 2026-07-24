import 'package:equatable/equatable.dart';

import '../../../models/ecosystem_event.dart';
import '../../../models/event_registration.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {
  const EventInitial();
}

class EventLoading extends EventState {
  const EventLoading();
}

class EventsLoaded extends EventState {
  final List<EcosystemEvent> events;
  const EventsLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class EventDetailLoaded extends EventState {
  final EcosystemEvent event;
  const EventDetailLoaded(this.event);
  @override
  List<Object?> get props => [event];
}

class EventRegistered extends EventState {
  final EventRegistration registration;
  const EventRegistered(this.registration);
  @override
  List<Object?> get props => [registration];
}

class EventRegistrationsLoaded extends EventState {
  final List<EventRegistration> registrations;
  const EventRegistrationsLoaded(this.registrations);
  @override
  List<Object?> get props => [registrations];
}

class EventError extends EventState {
  final String message;
  const EventError(this.message);
  @override
  List<Object?> get props => [message];
}
