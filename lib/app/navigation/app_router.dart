import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/di/service_locator.dart';
import '../../domain/user/entities/user.dart';
import 'route_names.dart';
import 'guards/auth_guard.dart';
import 'guards/role_guard.dart';

// Import all screens that actually exist
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/property_details_screen.dart';
import '../../features/properties/screens/all_properties_screen.dart';
import '../../features/bookings/screens/my_bookings_screen.dart';
import '../../features/bookings/screens/booking_details_screen.dart';
import '../../features/bookings/screens/booking_request_screen.dart';
import '../../features/owner/screens/owner_dashboard_screen.dart';
import '../../features/owner/screens/owner_properties_screen.dart';
import '../../features/owner/screens/owner_property_edit_screen.dart';
import '../../features/owner/screens/owner_property_media_screen.dart';
import '../../features/owner/screens/owner_bookings_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/admin_properties_screen.dart';
import '../../features/admin/screens/admin_pending_properties_screen.dart';
import '../../features/admin/screens/admin_pending_kyc_screen.dart';
import '../../features/admin/screens/admin_user_management_screen.dart';
import '../../features/admin/screens/admin_settings_screen.dart';
import '../../features/profile/screens/kyc_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/reviews/screens/reviews_screen.dart';
import '../../features/reviews/screens/write_review_screen.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) async {
        final isAuthenticated = authProvider.isAuthenticated;
        final isOnboarding = state.matchedLocation == '/onboarding';
        final isSplash = state.matchedLocation == '/splash';
        final isAuthCheck = state.matchedLocation == '/auth-check';
        final isAuthRoute =
            state.matchedLocation.startsWith('/login') ||
            state.matchedLocation.startsWith('/register') ||
            state.matchedLocation.startsWith('/forgot') ||
            state.matchedLocation.startsWith('/reset');

        // Debug logging
        print(
          '🔍 Router redirect - Location: ${state.matchedLocation}, Authenticated: $isAuthenticated',
        );
        print('🔍 Router: authProvider instance: $authProvider');
        print(
          '🔍 Router: authProvider.isAuthenticated: ${authProvider.isAuthenticated}',
        );

        // Don't redirect if we're on the splash screen - let it handle its own navigation
        if (isSplash) {
          print('🔍 On splash screen, no redirect');
          return null;
        }

        // Handle auth-check route - redirect to appropriate role-based route
        if (isAuthCheck && isAuthenticated) {
          print('🔍 On auth-check route, getting user role...');
          try {
            final user = await ServiceLocator().userRepository.getCurrentUser();
            final roleRoute = RoleGuard.getRoleHomeRoute(user.role);
            print('🔍 User role: ${user.role}, redirecting to: $roleRoute');
            return roleRoute;
          } catch (e) {
            print('🔍 Error getting user role: $e');
            return '/home'; // Default fallback
          }
        }

        // If not authenticated and not on auth/onboarding routes, redirect to login
        if (!isAuthenticated && !isAuthRoute && !isOnboarding) {
          print('🔍 Not authenticated, redirecting to login');
          return '/login';
        }

        // If authenticated and on auth routes, redirect to role home
        if (isAuthenticated && isAuthRoute) {
          print('🔍 Authenticated on auth route, getting user role...');
          try {
            final user = await ServiceLocator().userRepository.getCurrentUser();
            final roleRoute = RoleGuard.getRoleHomeRoute(user.role);
            print('🔍 User role: ${user.role}, redirecting to: $roleRoute');
            return roleRoute;
          } catch (e) {
            print('🔍 Error getting user role: $e');
            return '/home'; // Default fallback
          }
        }

        // If authenticated and on onboarding, redirect to role home
        if (isAuthenticated && isOnboarding) {
          print('🔍 Authenticated on onboarding, getting user role...');
          try {
            final user = await ServiceLocator().userRepository.getCurrentUser();
            final roleRoute = RoleGuard.getRoleHomeRoute(user.role);
            print('🔍 User role: ${user.role}, redirecting to: $roleRoute');
            return roleRoute;
          } catch (e) {
            print('🔍 Error getting user role: $e');
            return '/home'; // Default fallback
          }
        }

        print('🔍 No redirect needed');
        return null; // No redirect needed
      },
      routes: [
        // Splash and Onboarding
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        // Auth Routes
        GoRoute(
          path: '/auth-check',
          builder: (context, state) =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/reset',
          builder: (context, state) => const ResetPasswordScreen(),
        ),

        // Tenant Routes
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/properties',
          builder: (context, state) => const AllPropertiesScreen(),
        ),
        GoRoute(
          path: '/properties/:id',
          builder: (context, state) {
            final propertyId = state.pathParameters['id'] ?? '';
            return PropertyDetailsScreen(propertyId: propertyId);
          },
        ),

        // Booking Routes
        GoRoute(
          path: '/bookings/my',
          builder: (context, state) => const MyBookingsScreen(),
        ),
        GoRoute(
          path: '/bookings/request',
          builder: (context, state) {
            final propertyId = state.uri.queryParameters['propertyId'] ?? '';
            return BookingRequestScreen(propertyId: propertyId);
          },
        ),
        GoRoute(
          path: '/bookings/:id',
          builder: (context, state) {
            final bookingId = state.pathParameters['id'] ?? '';
            return BookingDetailsScreen(bookingId: bookingId);
          },
        ),

        // Owner Routes
        GoRoute(
          path: '/owner',
          builder: (context, state) => const OwnerDashboardScreen(),
        ),
        GoRoute(
          path: '/owner/properties',
          builder: (context, state) => const OwnerPropertiesScreen(),
        ),
        GoRoute(
          path: '/owner/properties/:id/edit',
          builder: (context, state) {
            final propertyId = state.pathParameters['id'] ?? '';
            return OwnerPropertyEditScreen(propertyId: propertyId);
          },
        ),
        GoRoute(
          path: '/owner/properties/:id/media',
          builder: (context, state) {
            final propertyId = state.pathParameters['id'] ?? '';
            return OwnerPropertyMediaScreen(propertyId: propertyId);
          },
        ),
        GoRoute(
          path: '/owner/bookings',
          builder: (context, state) => const OwnerBookingsScreen(),
        ),

        // Wallet Routes
        GoRoute(
          path: '/wallet',
          builder: (context, state) => const WalletScreen(),
        ),

        // Admin Routes
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/properties',
          builder: (context, state) => const AdminPropertiesScreen(),
        ),
        GoRoute(
          path: '/admin/pending-properties',
          builder: (context, state) => const AdminPendingPropertiesScreen(),
        ),
        GoRoute(
          path: '/admin/pending-kyc',
          builder: (context, state) => const AdminPendingKYCScreen(),
        ),
        GoRoute(
          path: '/admin/user-management',
          builder: (context, state) => const AdminUserManagementScreen(),
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (context, state) => const AdminSettingsScreen(),
        ),

        // Profile & Settings Routes
        GoRoute(
          path: '/profile/kyc',
          builder: (context, state) => const KycScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),

        // Reviews Routes
        GoRoute(
          path: '/reviews',
          builder: (context, state) {
            final propertyUuid = state.uri.queryParameters['propertyUuid'];
            final propertyTitle =
                state.uri.queryParameters['propertyTitle'] ?? 'Property';
            if (propertyUuid != null) {
              return ReviewsScreen(
                propertyUuid: propertyUuid,
                propertyTitle: propertyTitle,
              );
            }
            return const ReviewsScreen(
              propertyUuid: '',
              propertyTitle: 'Reviews',
            );
          },
        ),
        GoRoute(
          path: '/reviews/write',
          builder: (context, state) {
            final propertyId = state.uri.queryParameters['propertyId'] ?? '';
            final bookingId = state.uri.queryParameters['bookingId'];
            return WriteReviewScreen(
              propertyId: propertyId,
              bookingId: bookingId,
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for does not exist.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
