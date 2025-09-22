import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/di/service_locator.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = false;
  int _totalUsers = 0;
  int _totalProperties = 0;
  int _totalBookings = 0;
  int _pendingProperties = 0;
  int _pendingKYC = 0;
  double _totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      // Load various statistics with individual error handling
      int totalUsers = 0;
      int pendingPropertiesCount = 0;

      // Try to load users
      try {
        final users = await ServiceLocator().adminRepository.getUsers();
        totalUsers = users.length;
        print('✅ Admin Dashboard: Loaded ${totalUsers} users');
      } catch (e) {
        print('❌ Admin Dashboard: Error loading users: $e');
        // Continue without users data
      }

      // Try to load pending properties
      try {
        final pendingProperties = await ServiceLocator().adminRepository
            .getPendingProperties();
        pendingPropertiesCount = pendingProperties.length;
        print(
          '✅ Admin Dashboard: Loaded ${pendingPropertiesCount} pending properties',
        );
      } catch (e) {
        print('❌ Admin Dashboard: Error loading pending properties: $e');
        // Continue without pending properties data
      }

      setState(() {
        _totalUsers = totalUsers;
        _pendingProperties = pendingPropertiesCount;
        // TODO: Load other statistics when APIs are available
        _totalProperties = 0; // Placeholder
        _totalBookings = 0; // Placeholder
        _pendingKYC = 0; // Placeholder
        _totalRevenue = 0.0; // Placeholder
      });

      print('✅ Admin Dashboard: Data loaded successfully');
    } catch (e) {
      print('❌ Admin Dashboard: General error: $e');
      // Don't show error to user anymore, just log it
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            color: isDark ? AppColors.gray100 : AppColors.gray900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadDashboardData,
            icon: Icon(Icons.refresh, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 24),
                    _buildStatisticsGrid(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryCoral,
            AppColors.primaryCoral.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCoral.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Welcome, Administrator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your platform and monitor activity',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Platform Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.gray100 : AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              'Total Users',
              _totalUsers.toString(),
              Icons.people,
              AppColors.primaryCoral,
            ),
            _buildStatCard(
              'Total Properties',
              _totalProperties.toString(),
              Icons.home,
              Colors.blue,
            ),
            _buildStatCard(
              'Total Bookings',
              _totalBookings.toString(),
              Icons.book_online,
              Colors.green,
            ),
            _buildStatCard(
              'Total Revenue',
              'LYD ${_totalRevenue.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.orange,
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
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark
            ? Border.all(
                color: AppColors.gray700.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Icon(Icons.trending_up, color: Colors.green, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.gray100 : AppColors.gray900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isDark ? AppColors.gray400 : AppColors.gray600,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.gray100 : AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: [
            _buildActionCard(
              'Pending Properties',
              '$_pendingProperties properties need review',
              Icons.home_work,
              Colors.orange,
              () => _navigateToPendingProperties(),
            ),
            _buildActionCard(
              'Pending KYC',
              '$_pendingKYC users need verification',
              Icons.verified_user,
              Colors.blue,
              () => _navigateToPendingKYC(),
            ),
            _buildActionCard(
              'User Management',
              'Manage all platform users',
              Icons.people,
              AppColors.primaryCoral,
              () => _navigateToUserManagement(),
            ),
            _buildActionCard(
              'System Settings',
              'Configure platform settings',
              Icons.settings,
              AppColors.gray500,
              () => _navigateToSettings(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? AppColors.gray700.withValues(alpha: 0.3)
                : color.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? AppColors.gray500 : AppColors.gray400,
                  size: 12,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.gray100 : AppColors.gray900,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: isDark ? AppColors.gray400 : AppColors.gray600,
                fontSize: 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.gray100 : AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: isDark
                ? Border.all(
                    color: AppColors.gray700.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'New property submitted',
                'Villa in Tripoli',
                '2 hours ago',
                Icons.home,
                Colors.green,
              ),
              Divider(color: isDark ? AppColors.gray700 : AppColors.gray300),
              _buildActivityItem(
                'KYC verification completed',
                'Ahmed Ali',
                '4 hours ago',
                Icons.verified_user,
                Colors.blue,
              ),
              Divider(color: isDark ? AppColors.gray700 : AppColors.gray300),
              _buildActivityItem(
                'New user registered',
                'Sara Mohamed',
                '6 hours ago',
                Icons.person_add,
                AppColors.primaryCoral,
              ),
              Divider(color: isDark ? AppColors.gray700 : AppColors.gray300),
              _buildActivityItem(
                'Booking completed',
                'Property #123',
                '1 day ago',
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.gray100 : AppColors.gray900,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: isDark ? AppColors.gray500 : AppColors.gray500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToPendingProperties() {
    context.push('/admin/pending-properties');
  }

  void _navigateToPendingKYC() {
    context.push('/admin/pending-kyc');
  }

  void _navigateToUserManagement() {
    context.push('/admin/user-management');
  }

  void _navigateToSettings() {
    context.push('/admin/settings');
  }
}
