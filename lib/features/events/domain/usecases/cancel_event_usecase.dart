import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/event_repository.dart';

class CancelEventUseCase implements UseCase<void, CancelEventParams> {
  final EventRepository repository;

  CancelEventUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelEventParams params) async {
    return await repository.cancelEvent(params.eventId, params.organizerId);
  }
}

class CancelEventParams extends Equatable {
  final int eventId;
  final int organizerId;

  const CancelEventParams({required this.eventId, required this.organizerId});

  @override
  List<Object> get props => [eventId, organizerId];
}
