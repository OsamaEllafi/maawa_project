abstract class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppError: $message';
}

class NetworkError extends AppError {
  final int? statusCode;
  final String? url;

  const NetworkError({
    required super.message,
    this.statusCode,
    this.url,
    super.code,
    super.originalError,
  });

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
}

class ValidationError extends AppError {
  final Map<String, List<String>> fieldErrors;

  const ValidationError({
    required super.message,
    required this.fieldErrors,
    super.code,
    super.originalError,
  });

  List<String>? getFieldError(String field) => fieldErrors[field];
  
  bool hasFieldError(String field) => fieldErrors.containsKey(field);
  
  List<String> getAllErrors() {
    final errors = <String>[];
    for (final fieldErrors in fieldErrors.values) {
      errors.addAll(fieldErrors);
    }
    return errors;
  }
}

class AuthenticationError extends AppError {
  const AuthenticationError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class AuthorizationError extends AppError {
  const AuthorizationError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class ServerError extends AppError {
  const ServerError({
    required super.message,
    super.code,
    super.originalError,
  });
}

class UnknownError extends AppError {
  const UnknownError({
    required super.message,
    super.code,
    super.originalError,
  });
}
