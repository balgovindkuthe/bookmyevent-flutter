import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/event_model.dart';
import '../models/page_event_model.dart';
import '../models/ticket_tier_model.dart';

abstract class EventRemoteDataSource {
  Future<PageEventModel> getEvents(int page, int size);
  Future<EventModel> getEventById(int id);
  Future<EventModel> createEvent(int organizerId, String title, String description, String location, DateTime eventDate, int capacity);
  Future<EventModel> updateEvent(int eventId, String title, String description, String location, DateTime eventDate, int capacity);
  Future<EventModel> publishEvent(int eventId, int organizerId);
  Future<void> deleteEvent(int id);
  
  // Tiers
  Future<List<TicketTierModel>> getTiersForEvent(int eventId);
  Future<TicketTierModel> createTicketTier(int eventId, String name, double price, int capacity);
}

class EventRemoteDataSourceImpl implements EventRemoteDataSource {
  final ApiClient apiClient;

  EventRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PageEventModel> getEvents(int page, int size) async {
    try {
      final response = await apiClient.get(
        ApiConstants.events,
        queryParameters: {'page': page, 'size': size},
      );
      if (response.statusCode == 200) {
        return PageEventModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch events');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown Network Error');
    }
  }

  @override
  Future<EventModel> getEventById(int id) async {
    try {
      final response = await apiClient.get(ApiConstants.eventById(id));
      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch event details');
      }
    } on DioException catch (e) {
       if (e.response?.statusCode == 404) {
          throw ServerException('Event not found');
       }
      throw ServerException(e.message ?? 'Unknown Network Error');
    }
  }

  @override
  Future<EventModel> createEvent(int organizerId, String title, String description, String location, DateTime eventDate, int capacity) async {
    try {
      final response = await apiClient.post(
        ApiConstants.events,
        queryParameters: {'organizerId': organizerId},
        data: {
          'title': title,
          'description': description,
          'location': location,
          'eventDate': eventDate.toUtc().toIso8601String(),
          'capacity': capacity,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return EventModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create event');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown Error creating event');
    }
  }

  @override
  Future<EventModel> updateEvent(int eventId, String title, String description, String location, DateTime eventDate, int capacity) async {
    try {
      final response = await apiClient.put(
        ApiConstants.eventById(eventId),
        data: {
          'title': title,
          'description': description,
          'location': location,
          'eventDate': eventDate.toUtc().toIso8601String(),
          'capacity': capacity,
        },
      );
      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to update event');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown Error updating event');
    }
  }

  @override
  Future<EventModel> publishEvent(int eventId, int organizerId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.publishEvent(eventId),
        queryParameters: {'organizerId': organizerId},
      );
      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to publish event');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown Error publishing event');
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      final response = await apiClient.delete(ApiConstants.eventById(id));
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete event');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown Error deleting event');
    }
  }

  @override
  Future<List<TicketTierModel>> getTiersForEvent(int eventId) async {
    try {
      final response = await apiClient.get(ApiConstants.ticketTiers(eventId));
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => TicketTierModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to fetch ticket tiers');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error fetching tiers');
    }
  }

  @override
  Future<TicketTierModel> createTicketTier(int eventId, String name, double price, int capacity) async {
    try {
      final response = await apiClient.post(
        ApiConstants.ticketTiers(eventId),
        data: {
          'name': name,
          'price': price,
          'capacity': capacity,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TicketTierModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create ticket tier');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error creating ticket tier');
    }
  }
}
