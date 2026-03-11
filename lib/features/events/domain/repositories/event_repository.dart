import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event_entity.dart';
import '../entities/page_event_entity.dart';
import '../entities/ticket_tier_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, PageEventEntity>> getEvents(int page, int size);
  Future<Either<Failure, EventEntity>> getEventById(int id);
  Future<Either<Failure, EventEntity>> createEvent(int organizerId, String title, String description, String location, DateTime eventDate, int capacity);
  Future<Either<Failure, void>> deleteEvent(int id);
  // Tiers
  Future<Either<Failure, List<TicketTierEntity>>> getTiersForEvent(int eventId);
  Future<Either<Failure, TicketTierEntity>> createTicketTier(int eventId, String name, double price, int capacity);
}
