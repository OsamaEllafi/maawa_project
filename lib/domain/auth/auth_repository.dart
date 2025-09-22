import '../user/entities/user.dart';
import 'entities/session.dart';

abstract class AuthRepository {
  // Authentication
  Future<Session> login({
    required String email,
    required String password,
  });

  Future<Session> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<void> logout();

  Future<Session> refreshToken();

  // Password reset
  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  // Session management
  Future<Session?> getCurrentSession();
  Future<void> saveSession(Session session);
  Future<void> clearSession();
  Future<bool> hasValidSession();

  // User info
  Future<User> getCurrentUser();
}
