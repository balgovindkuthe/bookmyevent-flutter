import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ticket_tier_entity.dart';
import '../repositories/event_repository.dart';
import 'get_event_by_id_usecase.dart';

class GetTiersForEventUseCase implements UseCase<List<TicketTierEntity>, EventIdParams> {
  final EventRepository repository;

  GetTiersForEventUseCase(this.repository);

  @override
  Future<Either<Failure, List<TicketTierEntity>>> call(EventIdParams params) async {
    return await repository.getTiersForEvent(params.id);
  }
}
