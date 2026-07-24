import 'package:equatable/equatable.dart';

abstract class PitchEvent extends Equatable {
  const PitchEvent();

  @override
  List<Object?> get props => [];
}

class CreatePitch extends PitchEvent {
  final Map<String, dynamic> data;

  const CreatePitch(this.data);

  @override
  List<Object?> get props => [data];
}
