import 'package:dio/dio.dart';
import '../../core/errors/error_mapper.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/user/entities/profile.dart';
import '../../domain/user/entities/kyc.dart';
import '../network/dio_client.dart';

class UserApi {
  final DioClient _dioClient;

  UserApi(this._dioClient);

  // Profile management
  Future<User> getCurrentUser() async {
    try {
      final response = await _dioClient.get('/me');
      print('🌐 UserApi: Raw response data: ${response.data}');
      final data = response.data['data'] ?? response.data;
      print('🌐 UserApi: Processed data for User.fromJson: $data');
      return User.fromJson(data);
    } catch (error) {
      print('🌐 UserApi: Error in getCurrentUser: $error');
      print('🌐 UserApi: Error type: ${error.runtimeType}');
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<User> updateProfile(Profile profile) async {
    try {
      final response = await _dioClient.put('/me', data: profile.toJson());
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<String> uploadAvatar(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });

      final response = await _dioClient.upload(
        '/me/avatar',
        formData: formData,
      );
      final data = response.data['data'] ?? response.data;
      return data['avatar_url'] ?? data['avatar'];
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // KYC management
  Future<KYC> submitKYC({
    required String fullName,
    required String idNumber,
    required String iban,
  }) async {
    try {
      final response = await _dioClient.put(
        '/me/kyc',
        data: {'full_name': fullName, 'id_number': idNumber, 'iban': iban},
      );

      final data = response.data['data'] ?? response.data;
      return KYC.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<KYC?> getKYC() async {
    try {
      final response = await _dioClient.get('/me/kyc');
      final data = response.data['data'] ?? response.data;
      if (data == null) return null;
      return KYC.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Admin operations
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
}
