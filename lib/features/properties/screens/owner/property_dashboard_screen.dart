import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../demo/demo_data.dart';
import '../../../../demo/models.dart';

class PropertyDashboardScreen extends StatefulWidget {
  const PropertyDashboardScreen({super.key});

  @override
  State<PropertyDashboardScreen> createState() =>
      _PropertyDashboardScreenState();
}

class _PropertyDashboardScreenState extends State<PropertyDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _dashboardTabs = [
    'Overview',
    'Analytics',
    'Bookings',
    'Reviews',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _dashboardTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser!;

    // Get owner's properties
    final allProperties = DemoData.getPropertiesByOwner(currentUser.id);
    final publishedProperties = allProperties
        .where((p) => p.status == PropertyStatus.published)
        .toList();

    // Calculate analytics
    final totalBookings = _calculateTotalBookings(publishedProperties);
    final totalEarnings = _calculateTotalEarnings(publishedProperties);
    final averageRating = _calculateAverageRating(publishedProperties);
    final occupancyRate = _calculateOccupancyRate(publishedProperties);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Property Dashboard',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primaryCoral),
            onPressed: () => context.push('/property-editor'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primaryCoral,
          unselectedLabelColor: AppColors.gray600,
          indicatorColor: AppColors.primaryCoral,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: _dashboardTabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(
            publishedProperties,
            totalBookings,
            totalEarnings,
            averageRating,
            occupancyRate,
          ),
          _buildAnalyticsTab(publishedProperties),
          _buildBookingsTab(publishedProperties),
          _buildReviewsTab(publishedProperties),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(
    List<DemoProperty> properties,
    int totalBookings,
    double totalEarnings,
    double averageRating,
    double occupancyRate,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Properties',
                  '${properties.length}',
                  Icons.home_outlined,
                  AppColors.primaryCoral,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Bookings',
                  '$totalBookings',
                  Icons.calendar_today_outlined,
                  AppColors.primaryTurquoise,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Earnings',
                  '${totalEarnings.toStringAsFixed(0)} LYD',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Rating',
                  averageRating.toStringAsFixed(1),
                  Icons.star,
                  Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Performance Chart
          Text(
            'Performance This Month',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Occupancy Rate',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${occupancyRate.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryCoral,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(child: _buildOccupancyChart(occupancyRate)),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          _buildRecentActivityList(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab(List<DemoProperty> properties) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Chart
          Text(
            'Revenue Trends',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            height: 250,
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
            child: _buildRevenueChart(),
          ),

          const SizedBox(height: 32),

          // Property Performance
          Text(
            'Property Performance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          ...properties.map(
            (property) => _buildPropertyPerformanceCard(property),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsTab(List<DemoProperty> properties) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking Stats
          Row(
            children: [
              Expanded(
                child: _buildBookingStatCard(
                  'Upcoming',
                  '12',
                  Icons.schedule,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBookingStatCard(
                  'Active',
                  '3',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBookingStatCard(
                  'Completed',
                  '45',
                  Icons.done_all,
                  AppColors.gray600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Recent Bookings
          Text(
            'Recent Bookings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          _buildRecentBookingsList(),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(List<DemoProperty> properties) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Stats
          Row(
            children: [
              Expanded(
                child: _buildReviewStatCard(
                  'Average Rating',
                  '4.8',
                  Icons.star,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReviewStatCard(
                  'Total Reviews',
                  '156',
                  Icons.rate_review,
                  AppColors.primaryCoral,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Recent Reviews
          Text(
            'Recent Reviews',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),

          _buildRecentReviewsList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
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
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancyChart(double occupancyRate) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            width: (occupancyRate / 100) * double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryCoral,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Center(
            child: Text(
              '${occupancyRate.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    // Mock revenue chart
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly Revenue',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '12,450 LYD',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryCoral,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildChartBar(60, 'Jan'),
              _buildChartBar(80, 'Feb'),
              _buildChartBar(45, 'Mar'),
              _buildChartBar(90, 'Apr'),
              _buildChartBar(75, 'May'),
              _buildChartBar(85, 'Jun'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChartBar(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.primaryCoral,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
        ),
      ],
    );
  }

  Widget _buildPropertyPerformanceCard(DemoProperty property) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  property.images.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: AppColors.gray100,
                    child: const Icon(Icons.image, color: AppColors.gray400),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          property.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${property.reviewCount} reviews)',
                          style: TextStyle(
                            color: AppColors.gray600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPerformanceMetric(
                  'Bookings',
                  '${(property.reviewCount * 0.8).round()}',
                ),
              ),
              Expanded(
                child: _buildPerformanceMetric(
                  'Revenue',
                  '${(property.reviewCount * 0.8 * property.pricePerNight * 0.85).toStringAsFixed(0)} LYD',
                ),
              ),
              Expanded(
                child: _buildPerformanceMetric(
                  'Occupancy',
                  '${(property.reviewCount * 0.8 / 30 * 100).toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryCoral,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
        ),
      ],
    );
  }

  Widget _buildBookingStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final activities = [
      {
        'type': 'booking',
        'message': 'New booking for Modern Apartment',
        'time': '2 hours ago',
      },
      {
        'type': 'review',
        'message': '5-star review received',
        'time': '4 hours ago',
      },
      {
        'type': 'payment',
        'message': 'Payment received for Villa booking',
        'time': '1 day ago',
      },
      {
        'type': 'property',
        'message': 'Property status updated to Published',
        'time': '2 days ago',
      },
    ];

    return Column(
      children: activities
          .map((activity) => _buildActivityItem(activity))
          .toList(),
    );
  }

  Widget _buildActivityItem(Map<String, String> activity) {
    IconData icon;
    Color color;

    switch (activity['type']) {
      case 'booking':
        icon = Icons.calendar_today;
        color = AppColors.primaryCoral;
        break;
      case 'review':
        icon = Icons.star;
        color = Colors.amber;
        break;
      case 'payment':
        icon = Icons.payment;
        color = Colors.green;
        break;
      default:
        icon = Icons.home;
        color = AppColors.primaryTurquoise;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['message']!,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['time']!,
                  style: TextStyle(color: AppColors.gray600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsList() {
    // Mock recent bookings
    return Column(
      children: List.generate(5, (index) => _buildBookingItem(index)),
    );
  }

  Widget _buildBookingItem(int index) {
    final guests = [
      '2 guests',
      '4 guests',
      '1 guest',
      '6 guests',
      '3 guests',
    ][index];
    final dates = [
      'Dec 15-18',
      'Dec 20-25',
      'Dec 28-30',
      'Jan 5-10',
      'Jan 15-20',
    ][index];
    final amounts = [
      '450 LYD',
      '1,200 LYD',
      '285 LYD',
      '1,800 LYD',
      '675 LYD',
    ][index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primaryCoral.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.person, color: AppColors.primaryCoral),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guests,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  dates,
                  style: TextStyle(color: AppColors.gray600, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amounts[index],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryCoral,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReviewsList() {
    // Mock recent reviews
    return Column(
      children: List.generate(5, (index) => _buildReviewItem(index)),
    );
  }

  Widget _buildReviewItem(int index) {
    final ratings = [5, 4, 5, 3, 5][index];
    final comments = [
      'Amazing stay! Highly recommend.',
      'Great location and clean property.',
      'Perfect for our family vacation.',
      'Good but could be cleaner.',
      'Excellent host and beautiful property.',
    ][index];
    final dates = [
      '2 days ago',
      '3 days ago',
      '1 week ago',
      '1 week ago',
      '2 weeks ago',
    ][index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (starIndex) => Icon(
                  starIndex < ratings ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                dates[index],
                style: TextStyle(color: AppColors.gray600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comments[index], style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Analytics calculation methods
  int _calculateTotalBookings(List<DemoProperty> properties) {
    int total = 0;
    for (final property in properties) {
      total += (property.reviewCount * 0.8).round();
    }
    return total;
  }

  double _calculateTotalEarnings(List<DemoProperty> properties) {
    double total = 0.0;
    for (final property in properties) {
      final bookings = (property.reviewCount * 0.8).round();
      final earnings = bookings * property.pricePerNight * 0.85;
      total += earnings;
    }
    return total;
  }

  double _calculateAverageRating(List<DemoProperty> properties) {
    if (properties.isEmpty) return 0.0;

    double totalRating = 0.0;
    for (final property in properties) {
      totalRating += property.rating;
    }
    return totalRating / properties.length;
  }

  double _calculateOccupancyRate(List<DemoProperty> properties) {
    if (properties.isEmpty) return 0.0;

    double totalOccupancy = 0.0;
    for (final property in properties) {
      final bookings = (property.reviewCount * 0.8).round();
      final occupancy = (bookings / 30) * 100; // Assuming 30 days
      totalOccupancy += occupancy;
    }
    return totalOccupancy / properties.length;
  }
}
