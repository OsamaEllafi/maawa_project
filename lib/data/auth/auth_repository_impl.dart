import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/entities/session.dart';
import '../../domain/user/entities/user.dart';
import 'auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    return await _authApi.login(email: email, password: password);
  }

  @override
  Future<Session> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await _authApi.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  @override
  Future<void> logout() async {
    await _authApi.logout();
  }

  @override
  Future<Session> refreshToken() async {
    return await _authApi.refreshToken();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _authApi.forgotPassword(email: email);
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    await _authApi.resetPassword(
      token: token,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  @override
  Future<Session?> getCurrentSession() async {
    return await _authApi.getCurrentSession();
  }

  @override
  Future<void> saveSession(Session session) async {
    // This is handled by the AuthApi when logging in/registering
    // The session is automatically saved to secure storage
  }

  @override
  Future<void> clearSession() async {
    // This is handled by the AuthApi when logging out
    // The session is automatically cleared from secure storage
  }

  @override
  Future<bool> hasValidSession() async {
    return await _authApi.hasValidSession();
  }

  @override
  Future<User> getCurrentUser() async {
    return await _authApi.getCurrentUser();
  }
}
