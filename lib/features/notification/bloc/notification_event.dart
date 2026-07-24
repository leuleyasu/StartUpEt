import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class ConnectNotificationStream extends NotificationEvent {
  const ConnectNotificationStream();
}

class DisconnectNotificationStream extends NotificationEvent {
  const DisconnectNotificationStream();
}
