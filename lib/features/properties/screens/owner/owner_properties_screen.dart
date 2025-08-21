import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../demo/demo_data.dart';
import '../../../../demo/models.dart';

class OwnerPropertiesScreen extends StatefulWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<PropertyStatus> _statusTabs = [
    PropertyStatus.draft,
    PropertyStatus.pending,
    PropertyStatus.published,
    PropertyStatus.rejected,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
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
    
    // Calculate analytics
    final publishedProperties = allProperties.where((p) => p.status == PropertyStatus.published).length;
    final totalBookings = _calculateTotalBookings(allProperties);
    final totalEarnings = _calculateTotalEarnings(allProperties);
    final averageRating = _calculateAverageRating(allProperties);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Properties',
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
            onPressed: () {
              // Navigate to property editor
              context.push('/property-editor');
            },
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
          tabs: _statusTabs.map((status) {
            final count = allProperties.where((p) => p.status == status).length;
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_getStatusName(status)),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Analytics Dashboard
          if (publishedProperties > 0) ...[
            Container(
              padding: EdgeInsets.all(screenWidth * 0.06),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                border: Border(
                  bottom: BorderSide(color: AppColors.gray200, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnalyticsCard(
                          'Properties',
                          '$publishedProperties',
                          Icons.home_outlined,
                          AppColors.primaryCoral,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAnalyticsCard(
                          'Bookings',
                          '$totalBookings',
                          Icons.calendar_today_outlined,
                          AppColors.primaryTurquoise,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAnalyticsCard(
                          'Earnings',
                          '${totalEarnings.toStringAsFixed(0)} LYD',
                          Icons.attach_money,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAnalyticsCard(
                          'Rating',
                          averageRating.toStringAsFixed(1),
                          Icons.star,
                          Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _statusTabs.map((status) {
                final properties = allProperties.where((p) => p.status == status).toList();
                
                return _buildPropertyList(properties, status);
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to property editor
          context.push('/property-editor');
        },
        backgroundColor: AppColors.primaryCoral,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Property'),
      ),
    );
  }

  Widget _buildPropertyList(List<DemoProperty> properties, PropertyStatus status) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (properties.isEmpty) {
      return _buildEmptyState(status);
    }

    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.06),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildEmptyState(PropertyStatus status) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(status),
                size: 60,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _getEmptyStateTitle(status),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getEmptyStateSubtitle(status),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (status == PropertyStatus.draft) ...[
              GradientButton(
                text: 'Create Your First Property',
                onPressed: () {
                  context.push('/property-editor');
                },
                width: double.infinity,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(DemoProperty property) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Image.network(
                    property.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.gray100,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 48),
                        ),
                      );
                    },
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(property.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusName(property.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Actions menu
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) => _handlePropertyAction(value, property),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined),
                              SizedBox(width: 12),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'media',
                          child: Row(
                            children: [
                              Icon(Icons.photo_library_outlined),
                              SizedBox(width: 12),
                              Text('Manage Media'),
                            ],
                          ),
                        ),
                        if (property.status == PropertyStatus.draft)
                          const PopupMenuItem(
                            value: 'submit',
                            child: Row(
                              children: [
                                Icon(Icons.send_outlined),
                                SizedBox(width: 12),
                                Text('Submit for Review'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Property Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth < 400 ? 16 : 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (property.status == PropertyStatus.published) ...[
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            property.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, 
                        color: AppColors.gray600, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${property.location.city}, ${property.location.country}',
                        style: TextStyle(color: AppColors.gray600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Property details
                Row(
                  children: [
                    _buildPropertyDetail(Icons.people_outline, '${property.capacity} guests'),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(Icons.bed_outlined, '${property.bedrooms} beds'),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(Icons.bathtub_outlined, '${property.bathrooms} baths'),
                  ],
                ),
                const SizedBox(height: 12),
                // Price and performance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${property.pricePerNight} ${property.currency}/night',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryCoral,
                          ),
                        ),
                        if (property.status == PropertyStatus.published) ...[
                          Text(
                            '${property.reviewCount} reviews',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (property.status == PropertyStatus.published) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'This Month',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '1,250 LYD', // Mock earnings
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gray600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: AppColors.gray600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gray600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePropertyAction(String action, DemoProperty property) {
    switch (action) {
      case 'edit':
        context.push('/property-editor/${property.id}');
        break;
      case 'media':
        context.push('/property-media-manager/${property.id}');
        break;
      case 'submit':
        _showSubmitForReviewDialog(property);
        break;
      case 'delete':
        _showDeleteDialog(property);
        break;
    }
  }

  void _showSubmitForReviewDialog(DemoProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit for Review'),
        content: Text(
          'Are you sure you want to submit "${property.title}" for admin review? '
          'Once submitted, you won\'t be able to edit it until the review is complete.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitForReview(property);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(DemoProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text(
          'Are you sure you want to delete "${property.title}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProperty(property);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _submitForReview(DemoProperty property) {
    // Mock submission - in real app, this would update the backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${property.title} submitted for review'),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteProperty(DemoProperty property) {
    // Mock deletion - in real app, this would update the backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text('${property.title} deleted'),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getStatusName(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.draft:
        return 'Draft';
      case PropertyStatus.pending:
        return 'Pending';
      case PropertyStatus.published:
        return 'Published';
      case PropertyStatus.rejected:
        return 'Rejected';
    }
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.draft:
        return AppColors.gray500;
      case PropertyStatus.pending:
        return Colors.orange;
      case PropertyStatus.published:
        return Colors.green;
      case PropertyStatus.rejected:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.draft:
        return Icons.edit_note;
      case PropertyStatus.pending:
        return Icons.schedule;
      case PropertyStatus.published:
        return Icons.check_circle;
      case PropertyStatus.rejected:
        return Icons.cancel;
    }
  }

  String _getEmptyStateTitle(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.draft:
        return 'No drafts yet';
      case PropertyStatus.pending:
        return 'No pending properties';
      case PropertyStatus.published:
        return 'No published properties';
      case PropertyStatus.rejected:
        return 'No rejected properties';
    }
  }

  String _getEmptyStateSubtitle(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.draft:
        return 'Start by creating your first property listing';
      case PropertyStatus.pending:
        return 'Submit your drafts for admin review';
      case PropertyStatus.published:
        return 'Your approved properties will appear here';
      case PropertyStatus.rejected:
        return 'Properties that need revision will appear here';
    }
  }

  int _calculateTotalBookings(List<DemoProperty> properties) {
    int total = 0;
    for (final property in properties) {
      if (property.status == PropertyStatus.published) {
        // Mock booking count based on property rating and review count
        total += (property.reviewCount * 0.8).round(); // 80% of reviews represent bookings
      }
    }
    return total;
  }

  double _calculateTotalEarnings(List<DemoProperty> properties) {
    double total = 0.0;
    for (final property in properties) {
      if (property.status == PropertyStatus.published) {
        // Mock earnings calculation
        final bookings = (property.reviewCount * 0.8).round();
        final earnings = bookings * property.pricePerNight * 0.85; // 85% after platform fee
        total += earnings;
      }
    }
    return total;
  }

  double _calculateAverageRating(List<DemoProperty> properties) {
    final publishedProperties = properties.where((p) => p.status == PropertyStatus.published).toList();
    if (publishedProperties.isEmpty) return 0.0;
    
    double totalRating = 0.0;
    for (final property in publishedProperties) {
      totalRating += property.rating;
    }
    return totalRating / publishedProperties.length;
  }
}
