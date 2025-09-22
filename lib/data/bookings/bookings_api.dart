import '../../core/errors/error_mapper.dart';
import '../../domain/bookings/entities/booking.dart';
import '../network/dio_client.dart';

class BookingsApi {
  final DioClient _dioClient;

  BookingsApi(this._dioClient);

  // Tenant operations
  Future<List<Booking>> getTenantBookings({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioClient.get('/bookings', queryParameters: queryParams);
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => Booking.fromJson(json)).toList();
      } else if (data['bookings'] is List) {
        return (data['bookings'] as List).map((json) => Booking.fromJson(json)).toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<Booking> createBooking({
    required String propertyUuid,
    required int nights,
  }) async {
    try {
      final response = await _dioClient.post('/bookings', data: {
        'property_uuid': propertyUuid,
        'nights': nights,
      });

      final data = response.data['data'] ?? response.data;
      return Booking.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> cancelBooking(String bookingUuid, String reason) async {
    try {
      await _dioClient.post('/bookings/$bookingUuid/cancel', data: {
        'reason': reason,
      });
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Owner operations
  Future<List<Booking>> getOwnerBookings({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioClient.get('/owner/bookings', queryParameters: queryParams);
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => Booking.fromJson(json)).toList();
      } else if (data['bookings'] is List) {
        return (data['bookings'] as List).map((json) => Booking.fromJson(json)).toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> acceptBooking(String bookingUuid, String notes) async {
    try {
      await _dioClient.post('/owner/bookings/$bookingUuid/accept', data: {
        'notes': notes,
      });
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> rejectBooking(String bookingUuid, String notes) async {
    try {
      await _dioClient.post('/owner/bookings/$bookingUuid/reject', data: {
        'notes': notes,
      });
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> completeBooking(String bookingUuid, String notes) async {
    try {
      await _dioClient.post('/owner/bookings/$bookingUuid/complete', data: {
        'notes': notes,
      });
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Admin operations
  Future<void> cancelBookingAsAdmin(String bookingUuid, String reason) async {
    try {
      await _dioClient.post('/admin/bookings/$bookingUuid/cancel', data: {
        'reason': reason,
      });
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }
}
