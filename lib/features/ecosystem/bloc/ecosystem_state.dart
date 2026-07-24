import 'package:equatable/equatable.dart';

import '../../../models/booking.dart';
import '../../../models/ecosystem_application.dart';
import '../../../models/ecosystem_event.dart';
import '../../../models/event_attendee.dart';
import '../../../models/funding.dart';
import '../../../models/funding_application.dart';
import '../../../models/investment_pitch.dart';
import '../../../models/investment_profile.dart';
import '../../../models/news.dart';
import '../../../models/space.dart';

abstract class EcosystemState extends Equatable {
  const EcosystemState();

  @override
  List<Object?> get props => [];
}

class EcosystemInitial extends EcosystemState {
  const EcosystemInitial();
}

class EcosystemLoading extends EcosystemState {
  const EcosystemLoading();
}

class EcosystemSpacesLoaded extends EcosystemState {
  final List<Space> spaces;
  const EcosystemSpacesLoaded(this.spaces);
  @override
  List<Object?> get props => [spaces];
}

class EcosystemSpaceCreated extends EcosystemState {
  final Space space;
  const EcosystemSpaceCreated(this.space);
  @override
  List<Object?> get props => [space];
}

class EcosystemSpaceDeleted extends EcosystemState {
  const EcosystemSpaceDeleted();
}

class EcosystemEventsLoaded extends EcosystemState {
  final List<EcosystemEvent> events;
  const EcosystemEventsLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class EcosystemEventDetailLoaded extends EcosystemState {
  final EcosystemEvent event;
  const EcosystemEventDetailLoaded(this.event);
  @override
  List<Object?> get props => [event];
}

class EcosystemEventCreated extends EcosystemState {
  final EcosystemEvent event;
  const EcosystemEventCreated(this.event);
  @override
  List<Object?> get props => [event];
}

class EcosystemEventDeleted extends EcosystemState {
  const EcosystemEventDeleted();
}

class EcosystemAttendeesLoaded extends EcosystemState {
  final List<EventAttendee> attendees;
  const EcosystemAttendeesLoaded(this.attendees);
  @override
  List<Object?> get props => [attendees];
}

class EcosystemAttendeeAdded extends EcosystemState {
  final EventAttendee attendee;
  const EcosystemAttendeeAdded(this.attendee);
  @override
  List<Object?> get props => [attendee];
}

class EcosystemAttendeeRemoved extends EcosystemState {
  const EcosystemAttendeeRemoved();
}

class EcosystemFundingLoaded extends EcosystemState {
  final List<Funding> funding;
  const EcosystemFundingLoaded(this.funding);
  @override
  List<Object?> get props => [funding];
}

class EcosystemFundingDetailLoaded extends EcosystemState {
  final Funding funding;
  const EcosystemFundingDetailLoaded(this.funding);
  @override
  List<Object?> get props => [funding];
}

class EcosystemFundingDeleted extends EcosystemState {
  const EcosystemFundingDeleted();
}

class EcosystemFundingApplicationsLoaded extends EcosystemState {
  final List<FundingApplication> applications;
  const EcosystemFundingApplicationsLoaded(this.applications);
  @override
  List<Object?> get props => [applications];
}

class EcosystemInvestmentsPitchesLoaded extends EcosystemState {
  final List<InvestmentPitch> pitches;
  const EcosystemInvestmentsPitchesLoaded(this.pitches);
  @override
  List<Object?> get props => [pitches];
}

class EcosystemInvestmentsProfileLoaded extends EcosystemState {
  final InvestmentProfile profile;
  const EcosystemInvestmentsProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

class EcosystemNewsLoaded extends EcosystemState {
  final List<News> news;
  const EcosystemNewsLoaded(this.news);
  @override
  List<Object?> get props => [news];
}

class EcosystemNewsDetailLoaded extends EcosystemState {
  final News news;
  const EcosystemNewsDetailLoaded(this.news);
  @override
  List<Object?> get props => [news];
}

class EcosystemNewsCreated extends EcosystemState {
  final News news;
  const EcosystemNewsCreated(this.news);
  @override
  List<Object?> get props => [news];
}

class EcosystemNewsDeleted extends EcosystemState {
  const EcosystemNewsDeleted();
}

class EcosystemBookingsLoaded extends EcosystemState {
  final List<Booking> bookings;
  const EcosystemBookingsLoaded(this.bookings);
  @override
  List<Object?> get props => [bookings];
}

class EcosystemBookingCreated extends EcosystemState {
  final Booking booking;
  const EcosystemBookingCreated(this.booking);
  @override
  List<Object?> get props => [booking];
}

class EcosystemBookingDeleted extends EcosystemState {
  const EcosystemBookingDeleted();
}

class EcosystemApplicationsLoaded extends EcosystemState {
  final List<EcosystemApplication> applications;
  const EcosystemApplicationsLoaded(this.applications);
  @override
  List<Object?> get props => [applications];
}

class EcosystemApplicationDetailLoaded extends EcosystemState {
  final EcosystemApplication application;
  const EcosystemApplicationDetailLoaded(this.application);
  @override
  List<Object?> get props => [application];
}

class EcosystemApplicationSubmitted extends EcosystemState {
  final EcosystemApplication application;
  const EcosystemApplicationSubmitted(this.application);
  @override
  List<Object?> get props => [application];
}

class EcosystemError extends EcosystemState {
  final String message;
  const EcosystemError(this.message);
  @override
  List<Object?> get props => [message];
}
