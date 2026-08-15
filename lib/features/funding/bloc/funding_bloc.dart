import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/funding_service.dart';
import 'funding_event.dart';
import 'funding_state.dart';

class FundingBloc extends Bloc<FundingEvent, FundingState> {
  final FundingService _service;

  FundingBloc(this._service) : super(const FundingInitial()) {
    on<FetchFunding>(_onFetch);
    on<FetchFundingDetail>(_onFetchDetail);
    on<ApplyForFunding>(_onApply);
    on<FetchMyFundingApplications>(_onFetchApplications);
    on<SaveFunding>(_onSave);
  }

  Future<void> _onFetch(FetchFunding event, Emitter<FundingState> emit) async {
    emit(const FundingLoading());
    final r = await _service.getFunding();
    r.fold(
      (f) => emit(FundingError(f.message)),
      (d) => emit(FundingListLoaded(d)),
    );
  }

  Future<void> _onFetchDetail(
    FetchFundingDetail event,
    Emitter<FundingState> emit,
  ) async {
    emit(const FundingLoading());
    final r = await _service.getFundingDetail(event.id);
    r.fold(
      (f) => emit(FundingError(f.message)),
      (d) => emit(FundingDetailLoaded(d)),
    );
  }

  Future<void> _onApply(
    ApplyForFunding event,
    Emitter<FundingState> emit,
  ) async {
    emit(const FundingLoading());
    final r = await _service.applyForFunding(event.id, event.application);
    r.fold(
      (f) => emit(FundingError(f.message)),
      (d) => emit(FundingApplied(d)),
    );
  }

  Future<void> _onFetchApplications(
    FetchMyFundingApplications event,
    Emitter<FundingState> emit,
  ) async {
    emit(const FundingLoading());
    final r = await _service.getMyApplications();
    r.fold(
      (f) => emit(FundingError(f.message)),
      (d) => emit(FundingMyApplicationsLoaded(d)),
    );
  }

  Future<void> _onSave(SaveFunding event, Emitter<FundingState> emit) async {
    emit(const FundingLoading());
    final r = await _service.saveFunding(event.data);
    r.fold(
      (f) => emit(FundingError(f.message)),
      (isSaved) => emit(FundingSaved(isSaved)),
    );
  }
}
