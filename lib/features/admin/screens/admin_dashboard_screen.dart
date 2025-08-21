import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/user_model.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser!;

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryCoral,
            ),
            onPressed: _showNotifications,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth < 600 ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(currentUser, screenWidth),
            const SizedBox(height: 24),

            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 24),

            // Recent Activity
            _buildRecentActivity(),
            const SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 24),

            // System Health
            _buildSystemHealth(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(UserModel user, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryCoral, AppColors.primaryMagenta],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCoral.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${user.name}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s what\'s happening with your platform today',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final allProperties = DemoData.properties;
    final allUsers = DemoData.users;
    final allBookings = DemoData.bookings;
    final allTransactions = DemoData.transactions;

    final pendingProperties = allProperties
        .where((p) => p.status == PropertyStatus.pending)
        .length;
    final totalRevenue = allTransactions
        .where(
          (t) =>
              t.status == TransactionStatus.completed &&
              t.type == TransactionType.payment,
        )
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
          crossAxisSpacing: MediaQuery.of(context).size.width < 600 ? 0 : 16,
          mainAxisSpacing: MediaQuery.of(context).size.width < 600 ? 12 : 16,
          childAspectRatio: MediaQuery.of(context).size.width < 600 ? 2.2 : 1.5,
          children: [
            _buildStatCard(
              'Total Properties',
              allProperties.length.toString(),
              Icons.home_work,
              AppColors.primaryCoral,
              '${pendingProperties} pending review',
            ),
            _buildStatCard(
              'Total Users',
              allUsers.length.toString(),
              Icons.people,
              AppColors.primaryMagenta,
              '${allUsers.where((u) => u.kycStatus == KycStatus.pending).length} pending KYC',
            ),
            _buildStatCard(
              'Total Bookings',
              allBookings.length.toString(),
              Icons.calendar_today,
              AppColors.primaryTurquoise,
              '${allBookings.where((b) => b.status == BookingStatus.pendingPayment).length} pending payment',
            ),
            _buildStatCard(
              'Total Revenue',
              '${totalRevenue.toStringAsFixed(0)} LYD',
              Icons.attach_money,
              Colors.green,
              'This month',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.gray700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.gray500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final recentBookings = DemoData.bookings.take(5).toList();
    final recentProperties = DemoData.properties
        .where((p) => p.status == PropertyStatus.pending)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.gray900,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: _viewAllActivity,
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              if (recentProperties.isNotEmpty) ...[
                const Text(
                  'Properties Pending Review',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 12),
                ...recentProperties.map(
                  (property) => _buildActivityItem(
                    property.title,
                    'Submitted by ${DemoData.getUserById(property.ownerId)?.name ?? 'Unknown'}',
                    Icons.home_work_outlined,
                    AppColors.primaryCoral,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Text(
                'Recent Bookings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 12),
              ...recentBookings.map((booking) {
                final property = DemoData.getPropertyById(booking.propertyId);
                final user = DemoData.getUserById(booking.tenantId);
                return _buildActivityItem(
                  property?.title ?? 'Unknown Property',
                  'Booked by ${user?.name ?? 'Unknown'} - ${booking.status.name}',
                  Icons.calendar_today_outlined,
                  _getStatusColor(booking.status),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
          crossAxisSpacing: MediaQuery.of(context).size.width < 600 ? 0 : 16,
          mainAxisSpacing: MediaQuery.of(context).size.width < 600 ? 12 : 16,
          childAspectRatio: MediaQuery.of(context).size.width < 600 ? 3.5 : 2.5,
          children: [
            _buildActionCard(
              'Review Properties',
              Icons.home_work_outlined,
              AppColors.primaryCoral,
              _reviewProperties,
            ),
            _buildActionCard(
              'Manage Users',
              Icons.people_outlined,
              AppColors.primaryMagenta,
              _manageUsers,
            ),
            _buildActionCard(
              'View Bookings',
              Icons.calendar_today_outlined,
              AppColors.primaryTurquoise,
              _viewBookings,
            ),
            _buildActionCard(
              'System Settings',
              Icons.settings_outlined,
              AppColors.gray600,
              _systemSettings,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Health',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHealthItem(
                'Server Status',
                'Online',
                Icons.check_circle,
                Colors.green,
              ),
              _buildHealthItem(
                'Database',
                'Connected',
                Icons.storage,
                Colors.blue,
              ),
              _buildHealthItem(
                'API Response',
                'Fast',
                Icons.speed,
                Colors.orange,
              ),
              _buildHealthItem(
                'Storage',
                '85% Used',
                Icons.cloud,
                Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthItem(
    String title,
    String status,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.pendingPayment:
        return Colors.orange;
      case BookingStatus.requested:
        return Colors.blue;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.expired:
        return AppColors.gray500;
    }
  }

  // Action Methods
  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications panel coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewAllActivity() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity log coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _reviewProperties() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to property review...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _manageUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to user management...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewBookings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to booking management...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _systemSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigating to system settings...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
