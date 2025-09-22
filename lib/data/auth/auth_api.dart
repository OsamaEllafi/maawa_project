import 'package:dio/dio.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_mapper.dart';
import '../../domain/auth/entities/session.dart';
import '../../domain/user/entities/user.dart';
import '../network/dio_client.dart';

class AuthApi {
  final DioClient _dioClient;

  AuthApi(this._dioClient);

  // Simple health check to test server connectivity
  Future<bool> testConnection() async {
    try {
      print('🌐 AuthApi: Testing server connection...');
      final response = await _dioClient.get('/health');
      print(
        '🌐 AuthApi: Server is accessible - Status: ${response.statusCode}',
      );
      return true;
    } catch (error) {
      print('🌐 AuthApi: Server connection failed - $error');
      return false;
    }
  }

  // Authentication endpoints
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🌐 AuthApi: Making login request to /auth/login');
      print('🌐 AuthApi: Email: $email');

      // Test server connectivity first
      final isConnected = await testConnection();
      if (!isConnected) {
        throw const NetworkError(
          message:
              'Unable to connect to server. Please check your internet connection.',
          code: 'CONNECTION_FAILED',
        );
      }

      final response = await _dioClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      print(
        '🌐 AuthApi: Login response received - Status: ${response.statusCode}',
      );
      print('🌐 AuthApi: Response data: ${response.data}');

      final data = response.data['data'] ?? response.data;
      final session = Session.fromJson(data);

      // Store tokens in DioClient
      await _dioClient.setTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      print('🌐 AuthApi: Login successful, tokens stored');
      return session;
    } catch (error) {
      print('🌐 AuthApi: Login error - $error');
      print('🌐 AuthApi: Error type: ${error.runtimeType}');
      if (error is AppError) {
        print('🌐 AuthApi: AppError details - ${error.message}');
      }
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<Session> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      print('🌐 AuthApi: Making register request to /auth/register');
      print('🌐 AuthApi: Name: $name, Email: $email');

      // Temporarily skip health check to see if that's causing issues
      print('🌐 AuthApi: Skipping health check for now...');

      print('🌐 AuthApi: Making registration request...');
      final response = await _dioClient.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      print(
        '🌐 AuthApi: Register response received - Status: ${response.statusCode}',
      );
      print('🌐 AuthApi: Response data: ${response.data}');

      final data = response.data['data'] ?? response.data;
      final session = Session.fromJson(data);

      // Store tokens in DioClient
      await _dioClient.setTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      print('🌐 AuthApi: Registration successful, tokens stored');
      return session;
    } catch (error) {
      print('🌐 AuthApi: Register error - $error');
      print('🌐 AuthApi: Error type: ${error.runtimeType}');
      print('🌐 AuthApi: Error toString: ${error.toString()}');

      if (error is AppError) {
        print('🌐 AuthApi: AppError details - ${error.message}');
        print('🌐 AuthApi: AppError code - ${error.code}');
        if (error is ServerError) {
          print(
            '🌐 AuthApi: ServerError original error - ${error.originalError}',
          );
        }
      } else if (error is DioException) {
        print('🌐 AuthApi: DioException type: ${error.type}');
        print('🌐 AuthApi: DioException message: ${error.message}');
        print('🌐 AuthApi: DioException response: ${error.response?.data}');
        print('🌐 AuthApi: DioException status: ${error.response?.statusCode}');
      }

      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> logout() async {
    try {
      await _dioClient.post('/auth/logout');
    } catch (error) {
      // Even if logout fails on server, clear local tokens
      throw ErrorMapper.mapGenericError(error);
    } finally {
      await _dioClient.clearTokens();
    }
  }

  Future<Session> refreshToken() async {
    try {
      final refreshToken = await _dioClient.getRefreshToken();
      if (refreshToken == null) {
        throw const AuthenticationError(
          message: 'No refresh token available',
          code: 'NO_REFRESH_TOKEN',
        );
      }

      final response = await _dioClient.post(
        '/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      final data = response.data['data'] ?? response.data;
      final session = Session.fromJson(data);

      // Store new tokens
      await _dioClient.setTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      return session;
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Password reset endpoints
  Future<void> forgotPassword({required String email}) async {
    try {
      await _dioClient.post('/auth/forgot', data: {'email': email});
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _dioClient.post(
        '/auth/reset',
        data: {
          'token': token,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // User info endpoints
  Future<User> getCurrentUser() async {
    try {
      final response = await _dioClient.get('/auth/me');
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  Future<User> getUser() async {
    try {
      final response = await _dioClient.get('/user');
      final data = response.data['data'] ?? response.data;
      return User.fromJson(data);
    } catch (error) {
      throw ErrorMapper.mapGenericError(error);
    }
  }

  // Session management
  Future<Session?> getCurrentSession() async {
    final accessToken = await _dioClient.getAccessToken();
    final refreshToken = await _dioClient.getRefreshToken();

    if (accessToken == null) return null;

    return Session(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<bool> hasValidSession() async {
    return await _dioClient.hasValidToken();
  }
}
