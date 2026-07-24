import 'package:equatable/equatable.dart';

import '../../../models/verification_result.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object?> get props => [];
}

class VerificationInitial extends VerificationState {
  const VerificationInitial();
}

class VerificationLoading extends VerificationState {
  const VerificationLoading();
}

class VerificationResultLoaded extends VerificationState {
  final VerificationResult result;
  const VerificationResultLoaded(this.result);
  @override
  List<Object?> get props => [result];
}

class VerificationError extends VerificationState {
  final String message;
  const VerificationError(this.message);
  @override
  List<Object?> get props => [message];
}
