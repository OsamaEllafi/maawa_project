import '../../domain/bookings/bookings_repository.dart';
import '../../domain/bookings/entities/booking.dart';
import 'bookings_api.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsApi _bookingsApi;

  BookingsRepositoryImpl(this._bookingsApi);

  @override
  Future<List<Booking>> getTenantBookings({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    return await _bookingsApi.getTenantBookings(
      page: page,
      perPage: perPage,
      status: status,
    );
  }

  @override
  Future<Booking> createBooking({
    required String propertyUuid,
    required int nights,
  }) async {
    return await _bookingsApi.createBooking(
      propertyUuid: propertyUuid,
      nights: nights,
    );
  }

  @override
  Future<void> cancelBooking(String bookingUuid, String reason) async {
    await _bookingsApi.cancelBooking(bookingUuid, reason);
  }

  @override
  Future<List<Booking>> getOwnerBookings({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    return await _bookingsApi.getOwnerBookings(
      page: page,
      perPage: perPage,
      status: status,
    );
  }

  @override
  Future<void> acceptBooking(String bookingUuid, String notes) async {
    await _bookingsApi.acceptBooking(bookingUuid, notes);
  }

  @override
  Future<void> rejectBooking(String bookingUuid, String notes) async {
    await _bookingsApi.rejectBooking(bookingUuid, notes);
  }

  @override
  Future<void> completeBooking(String bookingUuid, String notes) async {
    await _bookingsApi.completeBooking(bookingUuid, notes);
  }

  @override
  Future<void> cancelBookingAsAdmin(String bookingUuid, String reason) async {
    await _bookingsApi.cancelBookingAsAdmin(bookingUuid, reason);
  }
}
