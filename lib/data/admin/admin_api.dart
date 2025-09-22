import '../../core/errors/error_mapper.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/properties/entities/property.dart';
import '../../domain/bookings/entities/booking.dart';
import '../../domain/reviews/entities/review.dart';
import '../../domain/wallet/entities/transaction.dart';
import '../../domain/admin/entities/mock_email.dart';
import '../network/dio_client.dart';

class AdminApi {
  final DioClient _dioClient;

  AdminApi(this._dioClient);

  // User management
  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? role,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (role != null && role.isNotEmpty) {
        queryParams['role'] = role;
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dioClient.get(
        '/admin/users',
        queryParameters: queryParams,
      );
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => User.fromJson(json)).toList();
      } else if (data['users'] is List) {
        return (data['users'] as List)
            .map((json) => User.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<User> promoteToOwner(String userUuid) async {
    try {
      final response = await _dioClient.post(
        '/admin/users/$userUuid/promote-to-owner',
      );
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<User> demoteToTenant(String userUuid) async {
    try {
      final response = await _dioClient.post(
        '/admin/users/$userUuid/demote-to-tenant',
      );
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<User> lockUser(String userUuid, String reason) async {
    try {
      final response = await _dioClient.post(
        '/admin/users/$userUuid/lock',
        data: {'reason': reason},
      );
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<User> unlockUser(String userUuid) async {
    try {
      final response = await _dioClient.post('/admin/users/$userUuid/unlock');
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // KYC management
  Future<void> verifyKYC(String userUuid, String notes) async {
    try {
      await _dioClient.post(
        '/admin/users/$userUuid/kyc/verify',
        data: {'notes': notes},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> rejectKYC(String userUuid, String notes) async {
    try {
      await _dioClient.post(
        '/admin/users/$userUuid/kyc/reject',
        data: {'notes': notes},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Property management
  Future<List<Property>> getPendingProperties({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _dioClient.get(
        '/admin/properties/pending',
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data['data'] ?? response.data;
      if (data is List) {
        return data.map((json) => Property.fromJson(json)).toList();
      } else if (data['properties'] is List) {
        return (data['properties'] as List)
            .map((json) => Property.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> approveProperty(String propertyUuid) async {
    try {
      await _dioClient.post('/admin/properties/$propertyUuid/approve');
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> rejectProperty(String propertyUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/properties/$propertyUuid/reject',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> unpublishProperty(String propertyUuid) async {
    try {
      await _dioClient.post('/admin/properties/$propertyUuid/unpublish');
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Booking management
  Future<void> cancelBooking(String bookingUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/bookings/$bookingUuid/cancel',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Review management
  Future<void> hideReview(String reviewUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/reviews/$reviewUuid/hide',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> unhideReview(String reviewUuid, String reason) async {
    try {
      await _dioClient.post(
        '/admin/reviews/$reviewUuid/unhide',
        data: {'reason': reason},
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Wallet management
  Future<Transaction> adjustUserWallet({
    required String userUuid,
    required double amount,
    required String reason,
    required String idempotencyKey,
    Map<String, dynamic>? meta,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'amount': amount,
        'reason': reason,
        'idempotency_key': idempotencyKey,
      };

      if (meta != null) {
        requestData['meta'] = meta;
      }

      final response = await _dioClient.post(
        '/admin/wallet/$userUuid/adjust',
        data: requestData,
      );
      final data = response.data['data'] ?? response.data;
      return Transaction.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Mock emails
  Future<List<MockEmail>> getMockEmails({
    int page = 1,
    int perPage = 20,
    String? user,
    String? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'per_page': perPage};

      if (user != null && user.isNotEmpty) {
        queryParams['user'] = user;
      }
      if (type != null && type.isNotEmpty) {
        queryParams['type'] = type;
      }

      final response = await _dioClient.get(
        '/admin/mock-emails',
        queryParameters: queryParams,
      );
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => MockEmail.fromJson(json)).toList();
      } else if (data['emails'] is List) {
        return (data['emails'] as List)
            .map((json) => MockEmail.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<MockEmail> getMockEmailDetails(String mockEmailUuid) async {
    try {
      final response = await _dioClient.get(
        '/admin/mock-emails/$mockEmailUuid',
      );
      final data = response.data['data'] ?? response.data;
      return MockEmail.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<List<MockEmail>> getMockEmailsForUser(String userUuid) async {
    try {
      final response = await _dioClient.get(
        '/admin/users/$userUuid/mock-emails',
      );
      final data = response.data['data'] ?? response.data;

      if (data is List) {
        return data.map((json) => MockEmail.fromJson(json)).toList();
      } else if (data['emails'] is List) {
        return (data['emails'] as List)
            .map((json) => MockEmail.fromJson(json))
            .toList();
      }

      return [];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<Map<String, dynamic>> getMockEmailStatistics() async {
    try {
      final response = await _dioClient.get('/admin/mock-emails/statistics');
      final data = response.data['data'] ?? response.data;
      return Map<String, dynamic>.from(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }
}
