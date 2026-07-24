import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/certificate_service.dart';
import 'certificate_event.dart';
import 'certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final CertificateService _service;

  CertificateBloc(this._service) : super(const CertificateInitial()) {
    on<DownloadCertificate>(_onDownload);
    on<DownloadCertificateAlt>(_onDownloadAlt);
    on<GenerateCertificatePdf>(_onGeneratePdf);
  }

  Future<void> _onDownload(
    DownloadCertificate event,
    Emitter<CertificateState> emit,
  ) async {
    emit(const CertificateLoading());
    final result = await _service.downloadCertificate(event.id);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (bytes) => emit(CertificateDownloaded(bytes)),
    );
  }

  Future<void> _onDownloadAlt(
    DownloadCertificateAlt event,
    Emitter<CertificateState> emit,
  ) async {
    emit(const CertificateLoading());
    final result = await _service.downloadCertificateAlt(event.id);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (bytes) => emit(CertificateDownloaded(bytes)),
    );
  }

  Future<void> _onGeneratePdf(
    GenerateCertificatePdf event,
    Emitter<CertificateState> emit,
  ) async {
    emit(const CertificateLoading());
    final result = await _service.generatePdf(event.data);
    result.fold(
      (failure) => emit(CertificateError(failure.message)),
      (cert) => emit(CertificatePdfGenerated(cert)),
    );
  }
}
