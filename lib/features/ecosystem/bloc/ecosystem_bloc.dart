import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/ecosystem_service.dart';
import 'ecosystem_event.dart';
import 'ecosystem_state.dart';

class EcosystemBloc extends Bloc<EcosystemEvent, EcosystemState> {
  final EcosystemService _service;

  EcosystemBloc(this._service) : super(const EcosystemInitial()) {
    on<FetchEcosystemSpaces>(_onFetchSpaces);
    on<CreateEcosystemSpace>(_onCreateSpace);
    on<UpdateEcosystemSpace>(_onUpdateSpace);
    on<DeleteEcosystemSpace>(_onDeleteSpace);
    on<FetchEcosystemEvents>(_onFetchEvents);
    on<FetchEcosystemEventDetail>(_onFetchEventDetail);
    on<CreateEcosystemEvent>(_onCreateEvent);
    on<UpdateEcosystemEvent>(_onUpdateEvent);
    on<DeleteEcosystemEvent>(_onDeleteEvent);
    on<FetchEcosystemEventAttendees>(_onFetchAttendees);
    on<AddEcosystemEventAttendee>(_onAddAttendee);
    on<UpdateEcosystemEventAttendee>(_onUpdateAttendee);
    on<RemoveEcosystemEventAttendee>(_onRemoveAttendee);
    on<FetchEcosystemFunding>(_onFetchFunding);
    on<FetchEcosystemFundingDetail>(_onFetchFundingDetail);
    on<UpdateEcosystemFunding>(_onUpdateFunding);
    on<DeleteEcosystemFunding>(_onDeleteFunding);
    on<FetchEcosystemFundingApplications>(_onFetchFundingApplications);
    on<UpdateEcosystemFundingApplication>(_onUpdateFundingApplication);
    on<FetchEcosystemInvestmentsPitches>(_onFetchInvestmentsPitches);
    on<FetchEcosystemInvestmentsProfile>(_onFetchInvestmentsProfile);
    on<UpdateEcosystemInvestmentsProfile>(_onUpdateInvestmentsProfile);
    on<FetchEcosystemNews>(_onFetchNews);
    on<FetchEcosystemNewsDetail>(_onFetchNewsDetail);
    on<CreateEcosystemNews>(_onCreateNews);
    on<UpdateEcosystemNews>(_onUpdateNews);
    on<DeleteEcosystemNews>(_onDeleteNews);
    on<FetchEcosystemBookings>(_onFetchBookings);
    on<CreateEcosystemBooking>(_onCreateBooking);
    on<UpdateEcosystemBooking>(_onUpdateBooking);
    on<DeleteEcosystemBooking>(_onDeleteBooking);
    on<ApplyToEcosystem>(_onApply);
    on<SubmitEcosystemApplication>(_onSubmitApplication);
  }

  Future<void> _onFetchSpaces(
    FetchEcosystemSpaces event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getSpaces();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemSpacesLoaded(d)),
    );
  }

  Future<void> _onCreateSpace(
    CreateEcosystemSpace event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.createSpace(event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemSpaceCreated(d)),
    );
  }

  Future<void> _onUpdateSpace(
    UpdateEcosystemSpace event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateSpace(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemSpaceCreated(d)),
    );
  }

  Future<void> _onDeleteSpace(
    DeleteEcosystemSpace event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.deleteSpace(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (_) => emit(const EcosystemSpaceDeleted()),
    );
  }

  Future<void> _onFetchEvents(
    FetchEcosystemEvents event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getEvents();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemEventsLoaded(d)),
    );
  }

  Future<void> _onFetchEventDetail(
    FetchEcosystemEventDetail event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getEvent(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemEventDetailLoaded(d)),
    );
  }

  Future<void> _onCreateEvent(
    CreateEcosystemEvent event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.createEvent(event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemEventCreated(d)),
    );
  }

  Future<void> _onUpdateEvent(
    UpdateEcosystemEvent event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateEvent(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemEventCreated(d)),
    );
  }

  Future<void> _onDeleteEvent(
    DeleteEcosystemEvent event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.deleteEvent(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (_) => emit(const EcosystemEventDeleted()),
    );
  }

  Future<void> _onFetchAttendees(
    FetchEcosystemEventAttendees event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getEventAttendees(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemAttendeesLoaded(d)),
    );
  }

  Future<void> _onAddAttendee(
    AddEcosystemEventAttendee event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.addEventAttendee(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemAttendeeAdded(d)),
    );
  }

  Future<void> _onUpdateAttendee(
    UpdateEcosystemEventAttendee event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateEventAttendee(
      event.id,
      event.attendeeId,
      event.data,
    );
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemAttendeeAdded(d)),
    );
  }

  Future<void> _onRemoveAttendee(
    RemoveEcosystemEventAttendee event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.removeEventAttendee(event.id, event.attendeeId);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (_) => emit(const EcosystemAttendeeRemoved()),
    );
  }

  Future<void> _onFetchFunding(
    FetchEcosystemFunding event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getFunding();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemFundingLoaded(d)),
    );
  }

  Future<void> _onFetchFundingDetail(
    FetchEcosystemFundingDetail event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getFundingById(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemFundingDetailLoaded(d)),
    );
  }

  Future<void> _onUpdateFunding(
    UpdateEcosystemFunding event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateFunding(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemFundingDetailLoaded(d)),
    );
  }

  Future<void> _onDeleteFunding(
    DeleteEcosystemFunding event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.deleteFunding(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (_) => emit(const EcosystemFundingDeleted()),
    );
  }

  Future<void> _onFetchFundingApplications(
    FetchEcosystemFundingApplications event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getFundingApplications();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemFundingApplicationsLoaded(d)),
    );
  }

  Future<void> _onUpdateFundingApplication(
    UpdateEcosystemFundingApplication event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateFundingApplication(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemFundingApplicationsLoaded([d])),
    );
  }

  Future<void> _onFetchInvestmentsPitches(
    FetchEcosystemInvestmentsPitches event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getInvestmentsPitches();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemInvestmentsPitchesLoaded(d)),
    );
  }

  Future<void> _onFetchInvestmentsProfile(
    FetchEcosystemInvestmentsProfile event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getInvestmentsProfile();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemInvestmentsProfileLoaded(d)),
    );
  }

  Future<void> _onUpdateInvestmentsProfile(
    UpdateEcosystemInvestmentsProfile event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateInvestmentsProfile(event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemInvestmentsProfileLoaded(d)),
    );
  }

  Future<void> _onFetchNews(
    FetchEcosystemNews event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getNews();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemNewsLoaded(d)),
    );
  }

  Future<void> _onFetchNewsDetail(
    FetchEcosystemNewsDetail event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getNewsById(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemNewsDetailLoaded(d)),
    );
  }

  Future<void> _onCreateNews(
    CreateEcosystemNews event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.createNews(event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemNewsCreated(d)),
    );
  }

  Future<void> _onUpdateNews(
    UpdateEcosystemNews event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateNews(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemNewsCreated(d)),
    );
  }

  Future<void> _onDeleteNews(
    DeleteEcosystemNews event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.deleteNews(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (_) => emit(const EcosystemNewsDeleted()),
    );
  }

  Future<void> _onFetchBookings(
    FetchEcosystemBookings event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.getBookings();
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemBookingsLoaded(d)),
    );
  }

  Future<void> _onCreateBooking(
    CreateEcosystemBooking event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.createBooking(event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemBookingCreated(d)),
    );
  }

  Future<void> _onUpdateBooking(
    UpdateEcosystemBooking event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.updateBooking(event.id, event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemBookingCreated(d)),
    );
  }

  Future<void> _onDeleteBooking(
    DeleteEcosystemBooking event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.deleteBooking(event.id);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (_) => emit(const EcosystemBookingDeleted()),
    );
  }

  Future<void> _onApply(
    ApplyToEcosystem event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.apply(
      data: event.data,
      queryParams: event.queryParams,
    );
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemApplicationsLoaded(d)),
    );
  }

  Future<void> _onSubmitApplication(
    SubmitEcosystemApplication event,
    Emitter<EcosystemState> emit,
  ) async {
    emit(const EcosystemLoading());
    final r = await _service.submitApplication(event.data);
    r.fold(
      (f) => emit(EcosystemError(f.message)),
      (d) => emit(EcosystemApplicationSubmitted(d)),
    );
  }
}
