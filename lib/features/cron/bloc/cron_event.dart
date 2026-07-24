import 'package:equatable/equatable.dart';

abstract class CronEvent extends Equatable {
  const CronEvent();

  @override
  List<Object?> get props => [];
}

class CheckExpirations extends CronEvent {
  const CheckExpirations();
}
