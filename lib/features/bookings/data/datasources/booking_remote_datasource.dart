import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(int eventId, int ticketTierId, int quantity);
  Future<BookingModel> getBookingById(int bookingId);
  Future<List<BookingModel>> getMyBookings();
  Future<BookingModel> markPaymentSuccess(int bookingId, String providerTxId);
  Future<void> cancelBooking(int bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BookingModel> createBooking(int eventId, int ticketTierId, int quantity) async {
    try {
      final response = await apiClient.post(
        ApiConstants.bookings,
        data: {
          'eventId': eventId,
          'ticketTierId': ticketTierId,
          'quantity': quantity,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BookingModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create booking');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error creating booking');
    }
  }

  @override
  Future<BookingModel> getBookingById(int bookingId) async {
    try {
      final response = await apiClient.get(ApiConstants.bookingById(bookingId));
      if (response.statusCode == 200) {
        return BookingModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to fetch booking');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error fetching booking');
    }
  }

  @override
  Future<List<BookingModel>> getMyBookings() async {
    try {
      final response = await apiClient.get(ApiConstants.customerBookings);
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => BookingModel.fromJson(e)).toList();
      } else {
        throw ServerException('Failed to fetch user bookings');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error fetching user bookings');
    }
  }

  @override
  Future<BookingModel> markPaymentSuccess(int bookingId, String providerTxId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.paymentSuccess(bookingId),
        queryParameters: {'providerTxId': providerTxId},
      );
      if (response.statusCode == 200) {
        return BookingModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to mark payment as successful');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error processing payment');
    }
  }

  @override
  Future<void> cancelBooking(int bookingId) async {
    try {
      final response = await apiClient.post(ApiConstants.cancelBooking(bookingId));
      if (response.statusCode != 200) {
        throw ServerException('Failed to cancel booking');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error cancelling booking');
    }
  }
}
