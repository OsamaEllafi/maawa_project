import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                route: '/home',
                isActive: currentLocation == '/home',
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Bookings',
                route: '/bookings/my',
                isActive: currentLocation == '/bookings/my',
              ),
              _buildNavItem(
                context,
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: 'Wallet',
                route: '/wallet',
                isActive: currentLocation == '/wallet',
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                route: '/profile',
                isActive: currentLocation == '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primaryCoral : AppColors.gray600,
                size: 22,
              ),

              const SizedBox(height: 2),

              // Label
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive ? AppColors.primaryCoral : AppColors.gray600,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom bottom navigation bar with enhanced design
class EnhancedBottomNav extends StatelessWidget {
  const EnhancedBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 88,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              _buildEnhancedNavItem(
                context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                route: '/home',
                isActive: currentLocation == '/home',
              ),
              _buildEnhancedNavItem(
                context,
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Bookings',
                route: '/bookings/my',
                isActive: currentLocation == '/bookings/my',
              ),
              _buildEnhancedNavItem(
                context,
                icon: Icons.account_balance_wallet_outlined,
                activeIcon: Icons.account_balance_wallet,
                label: 'Wallet',
                route: '/wallet',
                isActive: currentLocation == '/wallet',
              ),
              _buildEnhancedNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                route: '/profile',
                isActive: currentLocation == '/profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryCoral.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with animated background
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primaryCoral : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? Colors.white : AppColors.gray600,
                  size: 24,
                ),
              ),

              const SizedBox(height: 6),

              // Label with animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style:
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? AppColors.primaryCoral
                          : AppColors.gray600,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 12,
                    ) ??
                    const TextStyle(),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Floating Action Button style navigation
class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowMedium,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildFloatingNavItem(
              context,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              route: '/home',
              isActive: currentLocation == '/home',
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.calendar_today_outlined,
              activeIcon: Icons.calendar_today,
              label: 'Bookings',
              route: '/bookings/my',
              isActive: currentLocation == '/bookings/my',
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet,
              label: 'Wallet',
              route: '/wallet',
              isActive: currentLocation == '/wallet',
            ),
            _buildFloatingNavItem(
              context,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
              route: '/profile',
              isActive: currentLocation == '/profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => context.go(route),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primaryCoral : AppColors.gray600,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive ? AppColors.primaryCoral : AppColors.gray600,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
