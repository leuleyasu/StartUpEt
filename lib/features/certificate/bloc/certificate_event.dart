import 'package:equatable/equatable.dart';

abstract class CertificateEvent extends Equatable {
  const CertificateEvent();

  @override
  List<Object?> get props => [];
}

class DownloadCertificate extends CertificateEvent {
  final String id;

  const DownloadCertificate(this.id);

  @override
  List<Object?> get props => [id];
}

class DownloadCertificateAlt extends CertificateEvent {
  final String id;

  const DownloadCertificateAlt(this.id);

  @override
  List<Object?> get props => [id];
}

class GenerateCertificatePdf extends CertificateEvent {
  final Map<String, dynamic> data;

  const GenerateCertificatePdf(this.data);

  @override
  List<Object?> get props => [data];
}
