import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String baseUrl = kIsWeb ? 'http://localhost:8081/api/v1' : 'http://10.0.2.2:8081/api/v1'; // Emulator loopback or Web localhost
  // If running on physical device, change to local IP address

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Events
  static const String events = '/events';
  static String eventById(int id) => '/events/$id';
  static String publishEvent(int id) => '/events/$id/publish';
  static String cancelEvent(int id) => '/events/$id/cancel';

  // Tiers
  static String ticketTiers(int eventId) => '/events/$eventId/tiers';
  static String updateTicketTier(int eventId, int tierId) => '/events/$eventId/tiers/$tierId';

  // Bookings
  static const String bookings = '/bookings';
  static String bookingById(int id) => '/bookings/$id';
  static const String customerBookings = '/bookings/customer/me';
  static String paymentSuccess(int id) => '/bookings/$id/payment-success';
  static String cancelBooking(int id) => '/bookings/$id/cancel';

  // Checkin
  static const String checkInScan = '/checkin/scan';

  // Analytics
  static String eventAnalytics(int id) => '/analytics/events/$id';
}
