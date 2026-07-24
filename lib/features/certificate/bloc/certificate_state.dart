import 'package:equatable/equatable.dart';

import '../../../models/certificate.dart';

abstract class CertificateState extends Equatable {
  const CertificateState();

  @override
  List<Object?> get props => [];
}

class CertificateInitial extends CertificateState {
  const CertificateInitial();
}

class CertificateLoading extends CertificateState {
  const CertificateLoading();
}

class CertificateDownloaded extends CertificateState {
  final List<int> bytes;

  const CertificateDownloaded(this.bytes);

  @override
  List<Object?> get props => [bytes];
}

class CertificatePdfGenerated extends CertificateState {
  final Certificate certificate;

  const CertificatePdfGenerated(this.certificate);

  @override
  List<Object?> get props => [certificate];
}

class CertificateError extends CertificateState {
  final String message;

  const CertificateError(this.message);

  @override
  List<Object?> get props => [message];
}
