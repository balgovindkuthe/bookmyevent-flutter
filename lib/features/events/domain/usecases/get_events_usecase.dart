import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/page_event_entity.dart';
import '../repositories/event_repository.dart';
import 'package:equatable/equatable.dart';

class GetEventsUseCase implements UseCase<PageEventEntity, GetEventsParams> {
  final EventRepository repository;

  GetEventsUseCase(this.repository);

  @override
  Future<Either<Failure, PageEventEntity>> call(GetEventsParams params) async {
    return await repository.getEvents(params.page, params.size);
  }
}

class GetEventsParams extends Equatable {
  final int page;
  final int size;

  const GetEventsParams({required this.page, this.size = 10});

  @override
  List<Object> get props => [page, size];
}
