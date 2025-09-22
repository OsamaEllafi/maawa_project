import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/di/service_locator.dart';
import '../../domain/user/entities/user.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import 'bottom_nav.dart';
import 'owner_bottom_nav.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;

        // Show different layouts based on user role
        if (user == null) {
          return child; // No scaffold for unauthenticated users
        }

        switch (user.role) {
          case UserRole.tenant:
            return _buildTenantScaffold(context);
          case UserRole.owner:
            return _buildOwnerScaffold(context);
          case UserRole.admin:
            return _buildAdminScaffold(context);
        }
      },
    );
  }

  Widget _buildTenantScaffold(BuildContext context) {
    return Scaffold(body: child, bottomNavigationBar: const BottomNav());
  }

  Widget _buildOwnerScaffold(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const OwnerBottomNav(),
    );
  }

  Widget _buildAdminScaffold(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Always show side navigation for admin
            _buildSideNavigation(context, _getAdminNavItems()),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray50,
                  border: Border(
                    left: BorderSide(color: AppColors.gray200, width: 1),
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideNavigation(BuildContext context, List<NavItem> items) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(right: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'frontend/assets/branding/Logo1.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MAAWA',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryCoral,
                      ),
                    ),
                    Text(
                      'Dashboard',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildSideNavItem(context, item);
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final user = authProvider.currentUser;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryCoral.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(
                          color: AppColors.primaryCoral,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'User',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user?.role.name.toUpperCase() ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.gray600),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavItem(BuildContext context, NavItem item) {
    final isSelected = _isCurrentRoute(context, item.route);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: isSelected ? AppColors.primaryCoral : AppColors.gray600,
          size: 20,
        ),
        title: Text(
          item.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? AppColors.primaryCoral : AppColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppColors.primaryCoral.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () => item.onTap(context),
      ),
    );
  }

  Widget _buildOwnerBottomNav(BuildContext context) {
    final items = _getOwnerNavItems();
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryCoral,
      unselectedItemColor: AppColors.gray600,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
      onTap: (index) => items[index].onTap(context),
    );
  }

  List<NavItem> _getOwnerNavItems() {
    return [
      NavItem(
        icon: Icons.home_work_outlined,
        label: 'Properties',
        route: '/owner/properties',
        onTap: (context) => context.go('/owner/properties'),
      ),
      NavItem(
        icon: Icons.calendar_today_outlined,
        label: 'Bookings',
        route: '/owner/bookings',
        onTap: (context) => context.go('/owner/bookings'),
      ),
      NavItem(
        icon: Icons.analytics_outlined,
        label: 'Analytics',
        route: '/owner/analytics',
        onTap: (context) => context.go('/owner/analytics'),
      ),
      NavItem(
        icon: Icons.person_outline,
        label: 'Profile',
        route: '/profile',
        onTap: (context) => context.go('/profile'),
      ),
    ];
  }

  List<NavItem> _getAdminNavItems() {
    return [
      NavItem(
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        route: '/admin',
        onTap: (context) => context.go('/admin'),
      ),
      NavItem(
        icon: Icons.home_work_outlined,
        label: 'Properties',
        route: '/admin/properties',
        onTap: (context) => context.go('/admin/properties'),
      ),
      NavItem(
        icon: Icons.people_outline,
        label: 'Users',
        route: '/admin/users',
        onTap: (context) => context.go('/admin/users'),
      ),
      NavItem(
        icon: Icons.calendar_today_outlined,
        label: 'Bookings',
        route: '/admin/bookings',
        onTap: (context) => context.go('/admin/bookings'),
      ),
      NavItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Wallet Adjust',
        route: '/admin/wallet-adjust',
        onTap: (context) => context.go('/admin/wallet-adjust'),
      ),
      NavItem(
        icon: Icons.email_outlined,
        label: 'Mock Emails',
        route: '/admin/mock-emails',
        onTap: (context) => context.go('/admin/mock-emails'),
      ),
      NavItem(
        icon: Icons.settings_outlined,
        label: 'Settings',
        route: '/settings',
        onTap: (context) => context.go('/settings'),
      ),
    ];
  }

  bool _isCurrentRoute(BuildContext context, String route) {
    final currentLocation = GoRouterState.of(context).uri.path;
    return currentLocation == route;
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String route;
  final Function(BuildContext) onTap;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.onTap,
  });
}
