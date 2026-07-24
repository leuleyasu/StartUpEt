import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _service;

  NotificationBloc(this._service) : super(const NotificationInitial()) {
    on<ConnectNotificationStream>(_onConnect);
    on<DisconnectNotificationStream>(_onDisconnect);
  }

  Future<void> _onConnect(
    ConnectNotificationStream event,
    Emitter<NotificationState> emit,
  ) async {
    final r = await _service.streamNotifications();
    r.fold(
      (f) => emit(NotificationError(f.message)),
      (d) => emit(NotificationConnected(d)),
    );
  }

  void _onDisconnect(
    DisconnectNotificationStream event,
    Emitter<NotificationState> emit,
  ) {
    emit(const NotificationDisconnected());
  }
}
