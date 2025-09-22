import 'package:dio/dio.dart';
import 'app_error.dart';

class ErrorMapper {
  static AppError mapDioError(DioException error) {
    print('🚨 ErrorMapper: Mapping DioError - Type: ${error.type}');
    print('🚨 ErrorMapper: DioError message: ${error.message}');
    print('🚨 ErrorMapper: DioError response: ${error.response?.data}');
    print(
      '🚨 ErrorMapper: DioError status code: ${error.response?.statusCode}',
    );

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkError(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const NetworkError(
          message:
              'No internet connection. Please check your network settings.',
          code: 'NO_CONNECTION',
        );

      case DioExceptionType.badResponse:
        return _mapResponseError(error.response);

      case DioExceptionType.cancel:
        return const NetworkError(
          message: 'Request was cancelled.',
          code: 'CANCELLED',
        );

      case DioExceptionType.unknown:
      default:
        return const UnknownError(
          message: 'An unexpected error occurred. Please try again.',
          code: 'UNKNOWN',
        );
    }
  }

  static AppError _mapResponseError(Response? response) {
    if (response == null) {
      return const UnknownError(
        message: 'No response received from server.',
        code: 'NO_RESPONSE',
      );
    }

    final statusCode = response.statusCode;
    final data = response.data;

    // Handle different status codes
    switch (statusCode) {
      case 401:
        return const AuthenticationError(
          message: 'Authentication failed. Please log in again.',
          code: 'UNAUTHORIZED',
        );

      case 403:
        return const AuthorizationError(
          message: 'You do not have permission to perform this action.',
          code: 'FORBIDDEN',
        );

      case 404:
        return NetworkError(
          message: 'Resource not found.',
          statusCode: statusCode,
          url: response.requestOptions.uri.toString(),
          code: 'NOT_FOUND',
        );

      case 422:
        return _mapValidationError(data);

      case 500:
      case 502:
      case 503:
      case 504:
        final errorMessage = _extractErrorMessage(data);
        print('🚨 ErrorMapper: Server error details - $errorMessage');
        print('🚨 ErrorMapper: Full server response - $data');
        return ServerError(
          message:
              errorMessage ?? 'Server error occurred. Please try again later.',
          code: 'SERVER_ERROR',
          originalError: data,
        );

      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return NetworkError(
            message: _extractErrorMessage(data) ?? 'Client error occurred.',
            statusCode: statusCode,
            url: response.requestOptions.uri.toString(),
            code: 'CLIENT_ERROR',
            originalError: data,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerError(
            message: _extractErrorMessage(data) ?? 'Server error occurred.',
            code: 'SERVER_ERROR',
            originalError: data,
          );
        } else {
          return UnknownError(
            message:
                _extractErrorMessage(data) ?? 'An unexpected error occurred.',
            code: 'UNKNOWN',
            originalError: data,
          );
        }
    }
  }

  static ValidationError _mapValidationError(dynamic data) {
    print('🚨 ErrorMapper: Mapping validation error - $data');

    final errors = data['errors'] as Map<String, dynamic>?;
    final message = _extractErrorMessage(data);

    if (errors != null) {
      // Extract field-specific errors
      final fieldErrors = <String, List<String>>{};
      errors.forEach((field, errorList) {
        if (errorList is List) {
          fieldErrors[field] = errorList.cast<String>();
        }
      });

      print('🚨 ErrorMapper: Field errors - $fieldErrors');

      return ValidationError(
        message: message ?? 'Validation failed',
        code: 'VALIDATION_ERROR',
        fieldErrors: fieldErrors,
        originalError: data,
      );
    }

    return ValidationError(
      message: message ?? 'Validation failed',
      code: 'VALIDATION_ERROR',
      fieldErrors: <String, List<String>>{},
      originalError: data,
    );
  }

  static String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    } else if (data is String) {
      return data;
    }
    return null;
  }

  static AppError mapGenericError(dynamic error) {
    if (error is AppError) {
      return error;
    } else if (error is DioException) {
      return mapDioError(error);
    } else if (error is Exception) {
      return UnknownError(
        message: error.toString(),
        code: 'EXCEPTION',
        originalError: error,
      );
    } else {
      return UnknownError(
        message: error?.toString() ?? 'An unknown error occurred.',
        code: 'UNKNOWN',
        originalError: error,
      );
    }
  }
}
