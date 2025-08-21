import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/user_model.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/property_details_screen.dart';
import '../../features/home/screens/profile_screen.dart';
import '../../features/properties/screens/all_properties_screen.dart';
import '../../features/bookings/screens/my_bookings_screen.dart';
import '../../features/bookings/screens/booking_details_screen.dart';
import '../../features/bookings/screens/booking_request_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/reviews/screens/reviews_screen.dart';
import '../../features/reviews/screens/write_review_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/admin_properties_screen.dart';
import '../../features/owner/screens/owner_dashboard_screen.dart';
import '../../features/owner/screens/owner_properties_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../ui/layouts/main_scaffold.dart';

class AppRouter {
  static GoRouter createRouter(AuthService authService) {
    return GoRouter(
      initialLocation: '/splash',
      redirect: (context, state) => _redirect(context, state),
      refreshListenable: authService,
      routes: [
        // Splash & Onboarding
        GoRoute(
          path: '/splash',
          name: 'splash',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(context, state, const SplashScreen()),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const OnboardingScreen(),
          ),
        ),

        // Authentication
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(context, state, const LoginScreen()),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(context, state, const RegisterScreen()),
        ),
        GoRoute(
          path: '/forgot',
          name: 'forgot',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const ForgotPasswordScreen(),
          ),
        ),
        GoRoute(
          path: '/reset',
          name: 'reset',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const ResetPasswordScreen(),
          ),
        ),

        // Main App with Bottom Navigation (Tenant)
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) =>
                  _buildPageWithTransition(context, state, const HomeScreen()),
            ),
            GoRoute(
              path: '/bookings/my',
              name: 'my-bookings',
              pageBuilder: (context, state) => _buildPageWithTransition(
                context,
                state,
                const MyBookingsScreen(),
              ),
            ),
            GoRoute(
              path: '/wallet',
              name: 'wallet',
              pageBuilder: (context, state) => _buildPageWithTransition(
                context,
                state,
                const WalletScreen(),
              ),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => _buildPageWithTransition(
                context,
                state,
                const ProfileScreen(),
              ),
            ),
          ],
        ),

        // Owner Routes
        GoRoute(
          path: '/owner/dashboard',
          name: 'owner-dashboard',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const OwnerDashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/owner/properties',
          name: 'owner-properties',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const OwnerPropertiesScreen(),
          ),
        ),
        GoRoute(
          path: '/owner/bookings',
          name: 'owner-bookings',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            _buildPlaceholderScreen('Owner Bookings'),
          ),
        ),
        GoRoute(
          path: '/owner/wallet',
          name: 'owner-wallet',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(context, state, const WalletScreen()),
        ),
        GoRoute(
          path: '/owner/profile',
          name: 'owner-profile',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(context, state, const ProfileScreen()),
        ),

        // All Properties (must come before property details to avoid conflict)
        GoRoute(
          path: '/properties/all',
          name: 'all-properties',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const AllPropertiesScreen(),
          ),
        ),

        // Property Details
        GoRoute(
          path: '/properties/:id',
          name: 'property-details',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            PropertyDetailsScreen(propertyId: state.pathParameters['id']!),
          ),
        ),

        // Booking routes
        GoRoute(
          path: '/booking-request/:propertyId',
          name: 'booking-request',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            BookingRequestScreen(
              propertyId: state.pathParameters['propertyId']!,
            ),
          ),
        ),
        GoRoute(
          path: '/reviews/:propertyId',
          name: 'reviews',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            ReviewsScreen(propertyId: state.pathParameters['propertyId']!),
          ),
        ),
        GoRoute(
          path: '/write-review/:propertyId',
          name: 'write-review',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            WriteReviewScreen(propertyId: state.pathParameters['propertyId']!),
          ),
        ),
        // Admin routes
        GoRoute(
          path: '/admin',
          name: 'admin-dashboard',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const AdminDashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/admin/properties',
          name: 'admin-properties',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            const AdminPropertiesScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) =>
              _buildPageWithTransition(context, state, const SettingsScreen()),
        ),
        GoRoute(
          path: '/bookings/:id',
          name: 'booking-details',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            BookingDetailsScreen(bookingId: state.pathParameters['id']!),
          ),
        ),

        GoRoute(
          path: '/about',
          name: 'about',
          pageBuilder: (context, state) => _buildPageWithTransition(
            context,
            state,
            _buildPlaceholderScreen('About'),
          ),
        ),
      ],
    );
  }

  // Keep a static reference for backward compatibility
  static GoRouter? _router;

  static GoRouter get router {
    if (_router == null) {
      throw Exception(
        'Router not initialized. Call AppRouter.createRouter() first.',
      );
    }
    return _router!;
  }

  static void initialize(AuthService authService) {
    _router = createRouter(authService);
  }

  // Route redirect logic
  static String? _redirect(BuildContext context, GoRouterState state) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.isAuthenticated;
    final currentLocation = state.uri.path;

    // Public routes that don't require authentication
    final publicRoutes = [
      '/splash',
      '/onboarding',
      '/login',
      '/register',
      '/forgot',
      '/reset',
    ];

    // If user is not logged in and trying to access protected route
    if (!isLoggedIn && !publicRoutes.contains(currentLocation)) {
      return '/login';
    }

    // If user is logged in and trying to access auth routes
    if (isLoggedIn && publicRoutes.contains(currentLocation)) {
      final user = authService.currentUser;
      if (user != null) {
        switch (user.role) {
          case UserRole.tenant:
            return '/home';
          case UserRole.owner:
            return '/owner/dashboard';
          case UserRole.admin:
            return '/admin';
        }
      }
      return '/home';
    }

    return null; // No redirect needed
  }

  // Custom page transition builder using motion tokens
  static Page<void> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition with easing
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curveTween = CurveTween(curve: Curves.easeInOut);
        final offsetAnimation = animation
            .drive(curveTween)
            .drive(Tween(begin: begin, end: end));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  // Placeholder screen builder
  static Widget _buildPlaceholderScreen(String title) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              '$title Screen',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Navigation helpers
  static void goToHome(BuildContext context) {
    context.go('/home');
  }

  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  static void goToProfile(BuildContext context) {
    context.go('/profile');
  }

  static void goToProperty(BuildContext context, String propertyId) {
    context.push('/properties/$propertyId');
  }

  static void goToBookingRequest(BuildContext context, String propertyId) {
    context.push('/bookings/request?propertyId=$propertyId');
  }

  static void goToWallet(BuildContext context) {
    context.go('/wallet');
  }

  static void goToSettings(BuildContext context) {
    context.push('/settings');
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }
}
