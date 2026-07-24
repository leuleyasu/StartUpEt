import 'package:equatable/equatable.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  List<Object?> get props => [];
}

class VerifyNationalId extends VerificationEvent {
  final String nationalId;

  const VerifyNationalId(this.nationalId);

  @override
  List<Object?> get props => [nationalId];
}

class VerifyTin extends VerificationEvent {
  final String tin;

  const VerifyTin(this.tin);

  @override
  List<Object?> get props => [tin];
}
