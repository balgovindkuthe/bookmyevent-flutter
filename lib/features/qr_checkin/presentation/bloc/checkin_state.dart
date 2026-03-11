import 'package:equatable/equatable.dart';
import '../../domain/entities/checkin_entity.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final CheckInEntity checkInResult;

  const CheckInSuccess(this.checkInResult);

  @override
  List<Object?> get props => [checkInResult];
}

class CheckInError extends CheckInState {
  final String message;

  const CheckInError(this.message);

  @override
  List<Object?> get props => [message];
}
