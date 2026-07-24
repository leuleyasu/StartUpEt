import 'package:equatable/equatable.dart';

abstract class StartupEvent extends Equatable {
  const StartupEvent();

  @override
  List<Object?> get props => [];
}

class FetchStartupStatus extends StartupEvent {
  const FetchStartupStatus();
}

class RenewStartup extends StartupEvent {
  const RenewStartup();
}
