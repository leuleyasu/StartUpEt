import 'package:equatable/equatable.dart';

import '../../../models/notification_info.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationConnected extends NotificationState {
  final NotificationInfo notification;
  const NotificationConnected(this.notification);
  @override
  List<Object?> get props => [notification];
}

class NotificationDisconnected extends NotificationState {
  const NotificationDisconnected();
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}
