import 'package:equatable/equatable.dart';

import '../../../models/funding.dart';
import '../../../models/funding_application.dart';

abstract class FundingState extends Equatable {
  const FundingState();

  @override
  List<Object?> get props => [];
}

class FundingInitial extends FundingState {
  const FundingInitial();
}

class FundingLoading extends FundingState {
  const FundingLoading();
}

class FundingListLoaded extends FundingState {
  final List<Funding> funding;
  const FundingListLoaded(this.funding);
  @override
  List<Object?> get props => [funding];
}

class FundingDetailLoaded extends FundingState {
  final Funding detail;
  const FundingDetailLoaded(this.detail);
  @override
  List<Object?> get props => [detail];
}

class FundingApplied extends FundingState {
  final FundingApplication application;
  const FundingApplied(this.application);
  @override
  List<Object?> get props => [application];
}

class FundingMyApplicationsLoaded extends FundingState {
  final List<FundingApplication> applications;
  const FundingMyApplicationsLoaded(this.applications);
  @override
  List<Object?> get props => [applications];
}

class FundingSaved extends FundingState {
  final bool isSaved;
  const FundingSaved(this.isSaved);
  @override
  List<Object?> get props => [isSaved];
}

class FundingError extends FundingState {
  final String message;
  const FundingError(this.message);
  @override
  List<Object?> get props => [message];
}
