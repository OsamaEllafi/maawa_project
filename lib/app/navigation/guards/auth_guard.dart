import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/auth/entities/session.dart';

class AuthGuard {
  static Future<bool> canActivate(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Check if user is authenticated
    if (authProvider.isAuthenticated) {
      return true;
    }

    // Try to restore session from storage
    try {
      final session = await ServiceLocator().authRepository.getCurrentSession();
      if (session != null && session.isValid) {
        // Update auth provider state by checking auth status
        await authProvider.checkAuthStatus();
        return authProvider.isAuthenticated;
      }
    } catch (e) {
      // Session restoration failed, continue to login
    }

    // Not authenticated, redirect to login
    return false;
  }

  static Future<bool> handleUnauthorized(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      // Attempt token refresh
      await ServiceLocator().authRepository.refreshToken();
      
      // Refresh successful, update state
      await authProvider.checkAuthStatus();
      return authProvider.isAuthenticated;
    } catch (e) {
      // Refresh failed, force logout
      await authProvider.logout();
      return false;
    }
  }

  static String getRedirectRoute() {
    return '/login';
  }
}
