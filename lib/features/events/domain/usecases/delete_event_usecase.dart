import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/event_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteEventUseCase implements UseCase<void, DeleteEventParams> {
  final EventRepository repository;

  DeleteEventUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteEventParams params) async {
    return await repository.deleteEvent(params.eventId);
  }
}

class DeleteEventParams extends Equatable {
  final int eventId;

  const DeleteEventParams({required this.eventId});

  @override
  List<Object> get props => [eventId];
}
