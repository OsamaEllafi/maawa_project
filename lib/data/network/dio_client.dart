import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/error_mapper.dart';

class DioClient {
  static const String _tokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';

  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isRefreshing = false;
  final List<Future Function()> _pendingRequests = [];

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    print('🌐 DioClient: Initialized with baseUrl: ${AppConfig.apiBaseUrl}');
    print('🌐 DioClient: Full baseUrl: ${AppConfig.baseUrl}');

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor for adding auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _secureStorage.read(key: _tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (AppConfig.isDebug) {
            print('🌐 ${options.method} ${options.path}');
            print('🌐 Full URL: ${options.uri}');
            print('🌐 Request headers: ${options.headers}');
            if (options.data != null) {
              print('🌐 Request data: ${options.data}');
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.isDebug) {
            print('✅ ${response.statusCode} ${response.requestOptions.path}');
            print('📥 Response: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (AppConfig.isDebug) {
            print(
              '❌ ${error.response?.statusCode} ${error.requestOptions.path}',
            );
            print('📥 Error: ${error.response?.data}');
            print('📥 Error type: ${error.type}');
            print('📥 Error message: ${error.message}');
            if (error.response?.statusCode == 500) {
              print('📥 500 Error details: ${error.response?.data}');
              print('📥 500 Error headers: ${error.response?.headers}');
            }
          }

          // Handle 401 errors with token refresh
          if (error.response?.statusCode == 401) {
            try {
              final refreshed = await _refreshToken();
              if (refreshed) {
                // Retry the original request
                final token = await _secureStorage.read(key: _tokenKey);
                error.requestOptions.headers['Authorization'] = 'Bearer $token';

                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              }
            } catch (refreshError) {
              // Refresh failed, force logout
              await _forceLogout();
            }
          }

          handler.next(error);
        },
      ),
    );

    // Logging interceptor for debug mode
    if (AppConfig.isDebug) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => print(obj),
        ),
      );
    }
  }

  Future<bool> _refreshToken() async {
    if (_isRefreshing) {
      // Wait for the current refresh to complete
      await Future.delayed(const Duration(milliseconds: 100));
      return await _secureStorage.read(key: _tokenKey) != null;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) {
        _isRefreshing = false;
        return false;
      }

      final response = await _dio.post(
        '/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final newToken = data['access_token'];
        final newRefreshToken = data['refresh_token'];

        if (newToken != null) {
          await _secureStorage.write(key: _tokenKey, value: newToken);
          if (newRefreshToken != null) {
            await _secureStorage.write(
              key: _refreshTokenKey,
              value: newRefreshToken,
            );
          }
          _isRefreshing = false;
          return true;
        }
      }
    } catch (error) {
      if (AppConfig.isDebug) {
        print('Token refresh failed: $error');
      }
    }

    _isRefreshing = false;
    return false;
  }

  Future<void> _forceLogout() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    // TODO: Navigate to login screen or trigger logout callback
  }

  // HTTP Methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw ErrorMapper.mapDioError(error as DioException);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw ErrorMapper.mapDioError(error as DioException);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw ErrorMapper.mapDioError(error as DioException);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (error) {
      throw ErrorMapper.mapDioError(error as DioException);
    }
  }

  // File upload
  Future<Response> upload(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
    } catch (error) {
      throw ErrorMapper.mapDioError(error as DioException);
    }
  }

  // Token management
  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(key: _tokenKey, value: accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<bool> hasValidToken() async {
    final token = await _secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }
}
