import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../data/network/dio_client.dart';
import '../../data/auth/auth_api.dart';
import '../../data/auth/auth_repository_impl.dart';
import '../../data/user/user_api.dart';
import '../../data/user/user_repository_impl.dart';
import '../../data/properties/properties_api.dart';
import '../../data/properties/properties_repository_impl.dart';
import '../../data/bookings/bookings_api.dart';
import '../../data/bookings/bookings_repository_impl.dart';
import '../../data/wallet/wallet_api.dart';
import '../../data/wallet/wallet_repository_impl.dart';
import '../../data/reviews/reviews_api.dart';
import '../../data/reviews/reviews_repository_impl.dart';
import '../../data/admin/admin_api.dart';
import '../../data/admin/admin_repository_impl.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/user/user_repository.dart';
import '../../domain/properties/properties_repository.dart';
import '../../domain/bookings/bookings_repository.dart';
import '../../domain/wallet/wallet_repository.dart';
import '../../domain/reviews/reviews_repository.dart';
import '../../domain/admin/admin_repository.dart';
import '../../core/errors/app_error.dart';
import '../../core/providers/theme_provider.dart';
import '../../domain/user/entities/user.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final DioClient _dioClient;
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final PropertiesRepository _propertiesRepository;
  late final BookingsRepository _bookingsRepository;
  late final WalletRepository _walletRepository;
  late final ReviewsRepository _reviewsRepository;
  late final AdminRepository _adminRepository;

  Future<void> initialize() async {
    // Initialize core services
    _dioClient = DioClient();

    // Initialize APIs
    final authApi = AuthApi(_dioClient);
    final userApi = UserApi(_dioClient);
    final propertiesApi = PropertiesApi(_dioClient);
    final bookingsApi = BookingsApi(_dioClient);
    final walletApi = WalletApi(_dioClient);
    final reviewsApi = ReviewsApi(_dioClient);
    final adminApi = AdminApi(_dioClient);

    // Initialize repositories
    _authRepository = AuthRepositoryImpl(authApi);
    _userRepository = UserRepositoryImpl(userApi);
    _propertiesRepository = PropertiesRepositoryImpl(propertiesApi);
    _bookingsRepository = BookingsRepositoryImpl(bookingsApi);
    _walletRepository = WalletRepositoryImpl(walletApi);
    _reviewsRepository = ReviewsRepositoryImpl(reviewsApi);
    _adminRepository = AdminRepositoryImpl(adminApi);
  }

  // Getters for repositories
  AuthRepository get authRepository => _authRepository;
  UserRepository get userRepository => _userRepository;
  PropertiesRepository get propertiesRepository => _propertiesRepository;
  BookingsRepository get bookingsRepository => _bookingsRepository;
  WalletRepository get walletRepository => _walletRepository;
  ReviewsRepository get reviewsRepository => _reviewsRepository;
  AdminRepository get adminRepository => _adminRepository;
  DioClient get dioClient => _dioClient;

  // Provider setup
  static List<ChangeNotifierProvider> getProviders() {
    return [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(ServiceLocator().authRepository),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(ServiceLocator().userRepository),
      ),
      ChangeNotifierProvider<PropertiesProvider>(
        create: (context) =>
            PropertiesProvider(ServiceLocator().propertiesRepository),
      ),
      ChangeNotifierProvider<BookingsProvider>(
        create: (context) =>
            BookingsProvider(ServiceLocator().bookingsRepository),
      ),
      ChangeNotifierProvider<WalletProvider>(
        create: (context) => WalletProvider(ServiceLocator().walletRepository),
      ),
      ChangeNotifierProvider<ReviewsProvider>(
        create: (context) =>
            ReviewsProvider(ServiceLocator().reviewsRepository),
      ),
      ChangeNotifierProvider<AdminProvider>(
        create: (context) => AdminProvider(ServiceLocator().adminRepository),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
      ),
    ];
  }
}

// Auth Provider for state management
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;
  ValidationError? _validationError;
  User? _currentUser;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  ValidationError? get validationError => _validationError;
  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      print('🔐 AuthProvider: Attempting login for $email');
      final session = await _authRepository.login(
        email: email,
        password: password,
      );
      print(
        '🔐 AuthProvider: Login session received: ${session.accessToken.substring(0, 10)}...',
      );
      _isAuthenticated = true;
      print('🔐 AuthProvider: isAuthenticated set to: $_isAuthenticated');

      // Fetch current user after successful login
      try {
        _currentUser = await _authRepository.getCurrentUser();
        print('🔐 AuthProvider: Current user fetched successfully');
      } catch (userError) {
        print('🔐 AuthProvider: Error fetching current user: $userError');
        print('🔐 AuthProvider: Error type: ${userError.runtimeType}');
        // Don't fail the login if we can't get user details immediately
        // The user can still be fetched later
        _currentUser = null;
      }

      print(
        '🔐 AuthProvider: Login successful, isAuthenticated = $_isAuthenticated',
      );
      print('🔐 AuthProvider: Calling notifyListeners()');
      notifyListeners();
      print('🔐 AuthProvider: notifyListeners() called');
    } catch (e) {
      print('🔐 AuthProvider: Login failed - $e');
      print('🔐 AuthProvider: Error type: ${e.runtimeType}');
      if (e is AppError) {
        print('🔐 AuthProvider: AppError details - ${e.message}');
        _setError(e.message);
      } else {
        _setError(e.toString());
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      print('🔐 AuthProvider: Starting registration for $email');
      final session = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      _isAuthenticated = true;

      // Fetch current user after successful registration
      try {
        _currentUser = await _authRepository.getCurrentUser();
        print('🔐 AuthProvider: Current user fetched successfully');
      } catch (userError) {
        print('🔐 AuthProvider: Error fetching current user: $userError');
        // Don't fail the registration if we can't get user details immediately
        // The user can still be fetched later
      }

      print(
        '🔐 AuthProvider: Registration successful, isAuthenticated = $_isAuthenticated',
      );
      notifyListeners();
    } catch (e) {
      print('🔐 AuthProvider: Registration failed - $e');
      print('🔐 AuthProvider: Error type: ${e.runtimeType}');
      if (e is ValidationError) {
        print('🔐 AuthProvider: ValidationError details - ${e.message}');
        print('🔐 AuthProvider: Field errors - ${e.fieldErrors}');
        _validationError = e;
        _setError(e.message);
      } else if (e is AppError) {
        print('🔐 AuthProvider: AppError details - ${e.message}');
        _setError(e.message);
      } else {
        _setError(e.toString());
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authRepository.logout();
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      print('🔐 AuthProvider: Checking auth status...');
      final hasValidSession = await _authRepository.hasValidSession();
      _isAuthenticated = hasValidSession;

      if (hasValidSession) {
        // Fetch current user if session is valid
        try {
          _currentUser = await _authRepository.getCurrentUser();
          print('🔐 AuthProvider: Current user fetched during auth check');
        } catch (userError) {
          print(
            '🔐 AuthProvider: Error fetching current user during auth check: $userError',
          );
          // Keep authentication status but don't have user details
          _currentUser = null;
        }
      } else {
        _currentUser = null;
      }

      print(
        '🔐 AuthProvider: Auth status check result - isAuthenticated = $_isAuthenticated',
      );
      notifyListeners();
    } catch (e) {
      print('🔐 AuthProvider: Auth status check failed - $e');
      _isAuthenticated = false;
      _currentUser = null;
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    _validationError = null;
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    if (!_isAuthenticated) return;

    try {
      _currentUser = await _authRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      print('🔐 AuthProvider: Error fetching current user: $e');
    }
  }
}

// User Provider for state management
class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  UserProvider(this._userRepository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

// Properties Provider for state management
class PropertiesProvider extends ChangeNotifier {
  final PropertiesRepository _propertiesRepository;

  PropertiesProvider(this._propertiesRepository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

// Bookings Provider for state management
class BookingsProvider extends ChangeNotifier {
  final BookingsRepository _bookingsRepository;

  BookingsProvider(this._bookingsRepository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

// Wallet Provider for state management
class WalletProvider extends ChangeNotifier {
  final WalletRepository _walletRepository;

  WalletProvider(this._walletRepository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

// Reviews Provider for state management
class ReviewsProvider extends ChangeNotifier {
  final ReviewsRepository _reviewsRepository;

  ReviewsProvider(this._reviewsRepository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}

// Admin Provider for state management
class AdminProvider extends ChangeNotifier {
  final AdminRepository _adminRepository;

  AdminProvider(this._adminRepository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
