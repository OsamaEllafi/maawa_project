import 'entities/booking.dart';

abstract class BookingsRepository {
  // Tenant operations
  Future<List<Booking>> getTenantBookings({
    int page = 1,
    int perPage = 20,
    String? status,
  });

  Future<Booking> createBooking({
    required String propertyUuid,
    required int nights,
  });

  Future<void> cancelBooking(String bookingUuid, String reason);

  // Owner operations
  Future<List<Booking>> getOwnerBookings({
    int page = 1,
    int perPage = 20,
    String? status,
  });

  Future<void> acceptBooking(String bookingUuid, String notes);

  Future<void> rejectBooking(String bookingUuid, String notes);

  Future<void> completeBooking(String bookingUuid, String notes);

  // Admin operations
  Future<void> cancelBookingAsAdmin(String bookingUuid, String reason);
}
