import 'package:equatable/equatable.dart';

abstract class EcosystemEvent extends Equatable {
  const EcosystemEvent();

  @override
  List<Object?> get props => [];
}

class FetchEcosystemSpaces extends EcosystemEvent {
  const FetchEcosystemSpaces();
}

class CreateEcosystemSpace extends EcosystemEvent {
  final Map<String, dynamic> data;

  const CreateEcosystemSpace(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateEcosystemSpace extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateEcosystemSpace(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteEcosystemSpace extends EcosystemEvent {
  final String id;

  const DeleteEcosystemSpace(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchEcosystemEvents extends EcosystemEvent {
  const FetchEcosystemEvents();
}

class FetchEcosystemEventDetail extends EcosystemEvent {
  final String id;

  const FetchEcosystemEventDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateEcosystemEvent extends EcosystemEvent {
  final Map<String, dynamic> data;

  const CreateEcosystemEvent(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateEcosystemEvent extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateEcosystemEvent(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteEcosystemEvent extends EcosystemEvent {
  final String id;

  const DeleteEcosystemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchEcosystemEventAttendees extends EcosystemEvent {
  final String id;

  const FetchEcosystemEventAttendees(this.id);

  @override
  List<Object?> get props => [id];
}

class AddEcosystemEventAttendee extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const AddEcosystemEventAttendee(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class UpdateEcosystemEventAttendee extends EcosystemEvent {
  final String id;
  final String attendeeId;
  final Map<String, dynamic> data;

  const UpdateEcosystemEventAttendee(this.id, this.attendeeId, this.data);

  @override
  List<Object?> get props => [id, attendeeId, data];
}

class RemoveEcosystemEventAttendee extends EcosystemEvent {
  final String id;
  final String attendeeId;

  const RemoveEcosystemEventAttendee(this.id, this.attendeeId);

  @override
  List<Object?> get props => [id, attendeeId];
}

class FetchEcosystemFunding extends EcosystemEvent {
  const FetchEcosystemFunding();
}

class FetchEcosystemFundingDetail extends EcosystemEvent {
  final String id;

  const FetchEcosystemFundingDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateEcosystemFunding extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateEcosystemFunding(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteEcosystemFunding extends EcosystemEvent {
  final String id;

  const DeleteEcosystemFunding(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchEcosystemFundingApplications extends EcosystemEvent {
  const FetchEcosystemFundingApplications();
}

class UpdateEcosystemFundingApplication extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateEcosystemFundingApplication(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class FetchEcosystemInvestmentsPitches extends EcosystemEvent {
  const FetchEcosystemInvestmentsPitches();
}

class FetchEcosystemInvestmentsProfile extends EcosystemEvent {
  const FetchEcosystemInvestmentsProfile();
}

class UpdateEcosystemInvestmentsProfile extends EcosystemEvent {
  final Map<String, dynamic> data;

  const UpdateEcosystemInvestmentsProfile(this.data);

  @override
  List<Object?> get props => [data];
}

class FetchEcosystemNews extends EcosystemEvent {
  const FetchEcosystemNews();
}

class FetchEcosystemNewsDetail extends EcosystemEvent {
  final String id;

  const FetchEcosystemNewsDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateEcosystemNews extends EcosystemEvent {
  final Map<String, dynamic> data;

  const CreateEcosystemNews(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateEcosystemNews extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateEcosystemNews(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteEcosystemNews extends EcosystemEvent {
  final String id;

  const DeleteEcosystemNews(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchEcosystemBookings extends EcosystemEvent {
  const FetchEcosystemBookings();
}

class CreateEcosystemBooking extends EcosystemEvent {
  final Map<String, dynamic> data;

  const CreateEcosystemBooking(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateEcosystemBooking extends EcosystemEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateEcosystemBooking(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteEcosystemBooking extends EcosystemEvent {
  final String id;

  const DeleteEcosystemBooking(this.id);

  @override
  List<Object?> get props => [id];
}

class ApplyToEcosystem extends EcosystemEvent {
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? queryParams;

  const ApplyToEcosystem({this.data, this.queryParams});

  @override
  List<Object?> get props => [data, queryParams];
}

class SubmitEcosystemApplication extends EcosystemEvent {
  final Map<String, dynamic> data;

  const SubmitEcosystemApplication(this.data);

  @override
  List<Object?> get props => [data];
}
