import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/user/entities/user.dart';

class RoleGuard {
  static Future<bool> canActivate(BuildContext context, List<UserRole> requiredRoles) async {
    try {
      // Get current user from repository
      final user = await ServiceLocator().userRepository.getCurrentUser();
      
      // Check if user has any of the required roles
      return requiredRoles.contains(user.role);
    } catch (e) {
      // If we can't get user info, deny access
      return false;
    }
  }

  static String getRoleHomeRoute(UserRole role) {
    switch (role) {
      case UserRole.tenant:
        return '/home';
      case UserRole.owner:
        return '/owner/properties';
      case UserRole.admin:
        return '/admin';
    }
  }

  static String getInsufficientPermissionsRoute() {
    return '/home'; // Default to tenant home
  }

  static Widget buildInsufficientPermissionsUI(BuildContext context, String requiredRole) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insufficient Permissions'),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Access Denied',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You need $requiredRole permissions to access this page.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
