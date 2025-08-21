import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';
import 'package:go_router/go_router.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  String _selectedStatus = 'All';
  final List<String> _statusFilters = [
    'All',
    'Published',
    'Pending',
    'Draft',
    'Rejected',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final properties = _getFilteredProperties();

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: ThemeColors.getAppBarBackground(context),
            elevation: 0,
            floating: true,
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Property Dashboard',
                style: TextStyle(
                  color: ThemeColors.getTextPrimary(context),
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth < 400 ? 18 : 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryCoral.withValues(alpha: 0.1),
                      AppColors.primaryTurquoise.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add, color: ThemeColors.getGray700(context)),
                onPressed: () => _showAddPropertyDialog(),
              ),
            ],
          ),

          // Stats Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 16,
              ),
              child: _buildStatsCards(),
            ),
          ),

          // Status Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
                vertical: 8,
              ),
              child: _buildStatusFilter(),
            ),
          ),

          // Properties List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            sliver: properties.isEmpty
                ? SliverToBoxAdapter(child: _buildEmptyState())
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final property = properties[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPropertyCard(property),
                      );
                    }, childCount: properties.length),
                  ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = _getStats();
    final screenWidth = MediaQuery.of(context).size.width;

    // Use a responsive layout based on screen width
    if (screenWidth < 600) {
      // For smaller screens, use a 2x2 grid
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total',
                  stats['total'].toString(),
                  Icons.home,
                  AppColors.primaryCoral,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Published',
                  stats['published'].toString(),
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  stats['pending'].toString(),
                  Icons.pending,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Draft',
                  stats['draft'].toString(),
                  Icons.edit,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // For larger screens, use a single row
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Properties',
              stats['total'].toString(),
              Icons.home,
              AppColors.primaryCoral,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Published',
              stats['published'].toString(),
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Pending',
              stats['pending'].toString(),
              Icons.pending,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Draft',
              stats['draft'].toString(),
              Icons.edit,
              AppColors.info,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth < 600 ? 12 : 16),
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.getShadow(context),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth < 600 ? 6 : 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: screenWidth < 600 ? 16 : 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: screenWidth < 600 ? 18 : null,
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth < 600 ? 6 : 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ThemeColors.getGray600(context),
              fontWeight: FontWeight.w500,
              fontSize: screenWidth < 600 ? 11 : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _statusFilters.length,
        itemBuilder: (context, index) {
          final status = _statusFilters[index];
          final isSelected = _selectedStatus == status;

          return Padding(
            padding: EdgeInsets.only(
              right: index < _statusFilters.length - 1 ? 12 : 0,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedStatus = status),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryCoral
                      : ThemeColors.getGray50(context),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryCoral
                        : ThemeColors.getBorder(context),
                  ),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : ThemeColors.getGray700(context),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyCard(DemoProperty property) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeColors.getBorder(context)),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.getShadow(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Property Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  property.images.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: ThemeColors.getGray200(context),
                      child: Icon(
                        Icons.image_not_supported,
                        color: ThemeColors.getGray400(context),
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
              // Status Badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      property.status,
                    ).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    property.status.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Actions Menu
              Positioned(
                top: 12,
                right: 12,
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.more_vert, size: 20),
                  ),
                  onSelected: (value) => _handlePropertyAction(value, property),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 18),
                          SizedBox(width: 8),
                          Text('View Details'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'bookings',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18),
                          SizedBox(width: 8),
                          Text('View Bookings'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Property Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.getTextPrimary(context),
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${property.pricePerNight.toStringAsFixed(0)}/night',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryCoral,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: ThemeColors.getGray600(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${property.location.city}, ${property.location.country}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ThemeColors.getGray600(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildPropertyDetail(Icons.bed, '${property.bedrooms}'),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(
                      Icons.bathtub,
                      '${property.bathrooms}',
                    ),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(Icons.people, '${property.capacity}'),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          property.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: ThemeColors.getGray600(context)),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ThemeColors.getGray600(context),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 64,
            color: ThemeColors.getGray400(context),
          ),
          const SizedBox(height: 16),
          Text(
            'No properties found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: ThemeColors.getGray600(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first property to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ThemeColors.getGray500(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddPropertyDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Property'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  List<DemoProperty> _getFilteredProperties() {
    // Get properties owned by the current user (for demo, we'll use all properties)
    var properties = DemoData.properties;

    // Filter by status
    if (_selectedStatus != 'All') {
      properties = properties.where((property) {
        return property.status.displayName == _selectedStatus;
      }).toList();
    }

    return properties;
  }

  Map<String, int> _getStats() {
    final properties = DemoData.properties;
    return {
      'total': properties.length,
      'published': properties
          .where((p) => p.status == PropertyStatus.published)
          .length,
      'pending': properties
          .where((p) => p.status == PropertyStatus.pending)
          .length,
      'draft': properties.where((p) => p.status == PropertyStatus.draft).length,
    };
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.published:
        return AppColors.success;
      case PropertyStatus.pending:
        return AppColors.warning;
      case PropertyStatus.draft:
        return AppColors.info;
      case PropertyStatus.rejected:
        return AppColors.error;
    }
  }

  void _handlePropertyAction(String action, DemoProperty property) {
    switch (action) {
      case 'edit':
        // TODO: Navigate to edit property screen
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Edit ${property.title}')));
        break;
      case 'view':
        context.push('/properties/${property.id}');
        break;
      case 'bookings':
        // TODO: Navigate to property bookings screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('View bookings for ${property.title}')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(property);
        break;
    }
  }

  void _showDeleteConfirmation(DemoProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text(
          'Are you sure you want to delete "${property.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${property.title} deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddPropertyDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Property functionality coming soon!')),
    );
  }
}
