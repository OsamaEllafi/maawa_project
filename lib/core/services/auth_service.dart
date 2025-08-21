import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // Mock credentials for demo
  static const Map<String, Map<String, dynamic>> _mockUsers = {
    'admin@example.com': {
      'id': 'admin-001',
      'email': 'admin@example.com',
      'name': 'Admin User',
      'role': 'admin',
      'password': '123456',
      'avatar': null,
      'createdAt': '2024-01-01T00:00:00Z',
      'isVerified': true,
    },
    'owner@example.com': {
      'id': 'owner-001',
      'email': 'owner@example.com',
      'name': 'Property Owner',
      'role': 'owner',
      'password': '123456',
      'avatar': null,
      'createdAt': '2024-01-01T00:00:00Z',
      'isVerified': true,
    },
    'tenant@example.com': {
      'id': 'tenant-001',
      'email': 'tenant@example.com',
      'name': 'Tenant User',
      'role': 'tenant',
      'password': '123456',
      'avatar': null,
      'createdAt': '2024-01-01T00:00:00Z',
      'isVerified': true,
    },
  };

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      final userData = _mockUsers[email.toLowerCase()];
      
      if (userData != null && userData['password'] == password) {
        _currentUser = UserModel.fromJson(userData);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 2000));

    try {
      // In a real app, this would create a new user in the backend
      final newUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
        isVerified: false,
      );

      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Quick login methods for demo purposes
  Future<void> loginAsAdmin() => signIn('admin@example.com', '123456');
  Future<void> loginAsOwner() => signIn('owner@example.com', '123456');
  Future<void> loginAsTenant() => signIn('tenant@example.com', '123456');

  // Get demo credentials for UI display
  static List<Map<String, String>> getDemoCredentials() {
    return [
      {
        'email': 'admin@example.com',
        'password': '123456',
        'role': 'Admin',
      },
      {
        'email': 'owner@example.com',
        'password': '123456',
        'role': 'Property Owner',
      },
      {
        'email': 'tenant@example.com',
        'password': '123456',
        'role': 'Tenant',
      },
    ];
  }
}
