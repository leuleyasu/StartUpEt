import 'package:equatable/equatable.dart';

import '../../../models/pitch.dart';

abstract class PitchState extends Equatable {
  const PitchState();

  @override
  List<Object?> get props => [];
}

class PitchInitial extends PitchState {
  const PitchInitial();
}

class PitchLoading extends PitchState {
  const PitchLoading();
}

class PitchCreated extends PitchState {
  final Pitch pitch;
  const PitchCreated(this.pitch);
  @override
  List<Object?> get props => [pitch];
}

class PitchError extends PitchState {
  final String message;
  const PitchError(this.message);
  @override
  List<Object?> get props => [message];
}
