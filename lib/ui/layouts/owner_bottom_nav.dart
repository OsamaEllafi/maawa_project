import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_colors.dart';

class OwnerBottomNav extends StatelessWidget {
  const OwnerBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;
    
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getBottomNavBackground(context),
        border: Border(
          top: BorderSide(
            color: ThemeColors.getBorder(context),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.getShadow(context),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.dashboard,
                label: 'Dashboard',
                isActive: currentLocation == '/owner/dashboard',
                onTap: () => context.go('/owner/dashboard'),
              ),
              _buildNavItem(
                context,
                icon: Icons.home,
                label: 'Properties',
                isActive: currentLocation == '/owner/properties',
                onTap: () => context.go('/owner/properties'),
              ),
              _buildNavItem(
                context,
                icon: Icons.calendar_today,
                label: 'Bookings',
                isActive: currentLocation == '/owner/bookings',
                onTap: () => context.go('/owner/bookings'),
              ),
              _buildNavItem(
                context,
                icon: Icons.account_balance_wallet,
                label: 'Wallet',
                isActive: currentLocation == '/owner/wallet',
                onTap: () => context.go('/owner/wallet'),
              ),
              _buildNavItem(
                context,
                icon: Icons.person,
                label: 'Profile',
                isActive: currentLocation == '/owner/profile',
                onTap: () => context.go('/owner/profile'),
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
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryCoral.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? AppColors.primaryCoral
                  : ThemeColors.getGray600(context),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isActive
                    ? AppColors.primaryCoral
                    : ThemeColors.getGray600(context),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
