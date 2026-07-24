import 'package:equatable/equatable.dart';

abstract class FundingEvent extends Equatable {
  const FundingEvent();

  @override
  List<Object?> get props => [];
}

class FetchFunding extends FundingEvent {
  const FetchFunding();
}

class FetchFundingDetail extends FundingEvent {
  final String id;

  const FetchFundingDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class ApplyForFunding extends FundingEvent {
  final String id;
  final Map<String, dynamic> application;

  const ApplyForFunding(this.id, this.application);

  @override
  List<Object?> get props => [id, application];
}

class FetchMyFundingApplications extends FundingEvent {
  const FetchMyFundingApplications();
}

class SaveFunding extends FundingEvent {
  final Map<String, dynamic> data;

  const SaveFunding(this.data);

  @override
  List<Object?> get props => [data];
}
