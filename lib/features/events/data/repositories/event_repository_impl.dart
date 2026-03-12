import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../datasources/event_remote_datasource.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/page_event_entity.dart';
import '../../domain/entities/ticket_tier_entity.dart';
import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PageEventEntity>> getEvents(int page, int size) async {
    try {
      final remoteEvents = await remoteDataSource.getEvents(page, size);
      return Right(remoteEvents);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, EventEntity>> getEventById(int id) async {
    try {
      final remoteEvent = await remoteDataSource.getEventById(id);
      return Right(remoteEvent);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, EventEntity>> createEvent(int organizerId, String title, String description, String location, DateTime eventDate, int capacity) async {
    try {
      final remoteEvent = await remoteDataSource.createEvent(organizerId, title, description, location, eventDate, capacity);
      return Right(remoteEvent);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, EventEntity>> updateEvent(int eventId, String title, String description, String location, DateTime eventDate, int capacity) async {
    try {
      final remoteEvent = await remoteDataSource.updateEvent(eventId, title, description, location, eventDate, capacity);
      return Right(remoteEvent);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, EventEntity>> publishEvent(int eventId, int organizerId) async {
    try {
      final remoteEvent = await remoteDataSource.publishEvent(eventId, organizerId);
      return Right(remoteEvent);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(int id) async {
    try {
      await remoteDataSource.deleteEvent(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TicketTierEntity>>> getTiersForEvent(int eventId) async {
    try {
      final remoteTiers = await remoteDataSource.getTiersForEvent(eventId);
      return Right(remoteTiers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TicketTierEntity>> createTicketTier(int eventId, String name, double price, int capacity) async {
    try {
      final remoteTier = await remoteDataSource.createTicketTier(eventId, name, price, capacity);
      return Right(remoteTier);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
