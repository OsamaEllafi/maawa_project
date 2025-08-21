import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';

class AdminPropertiesScreen extends StatefulWidget {
  const AdminPropertiesScreen({super.key});

  @override
  State<AdminPropertiesScreen> createState() => _AdminPropertiesScreenState();
}

class _AdminPropertiesScreenState extends State<AdminPropertiesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  PropertyStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Property Management',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primaryCoral,
          labelColor: AppColors.primaryCoral,
          unselectedLabelColor: AppColors.gray600,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Published'),
            Tab(text: 'Rejected'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchBar(),
          
          // Properties List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPropertiesList(PropertyStatus.pending),
                _buildPropertiesList(PropertyStatus.published),
                _buildPropertiesList(PropertyStatus.rejected),
                _buildPropertiesList(null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search, color: AppColors.gray500),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.gray300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryCoral),
                ),
                filled: true,
                fillColor: AppColors.gray50,
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list, color: AppColors.primaryCoral),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesList(PropertyStatus? status) {
    var properties = DemoData.properties;

    // Filter by status
    if (status != null) {
      properties = properties.where((p) => p.status == status).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      properties = properties.where((p) =>
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.location.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          DemoData.getUserById(p.ownerId)?.name.toLowerCase().contains(_searchQuery.toLowerCase()) == true
      ).toList();
    }

    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_work_outlined,
              size: 64,
              color: AppColors.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(
                color: AppColors.gray600,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: AppColors.gray500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        final property = properties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildPropertyCard(DemoProperty property) {
    final owner = DemoData.getUserById(property.ownerId);
    final statusColor = _getStatusColor(property.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Property Image and Basic Info
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(property.images.first),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Status Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.status.name.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Price Badge
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${property.pricePerNight} ${property.currency}/night',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${property.rating} (${property.reviewCount})',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.gray500, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      property.location.city,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.gray500, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Owner: ${owner?.name ?? 'Unknown'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.bed, color: AppColors.gray500, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${property.bedrooms} beds • ${property.bathrooms} baths • ${property.capacity} guests',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Action Buttons
                if (property.status == PropertyStatus.pending) ...[
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Approve',
                          onPressed: () => _approveProperty(property),
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectProperty(property),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _viewPropertyDetails(property),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryCoral,
                            side: const BorderSide(color: AppColors.primaryCoral),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('View Details'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _editProperty(property),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.gray700,
                            side: const BorderSide(color: AppColors.gray300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Edit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.published:
        return Colors.green;
      case PropertyStatus.pending:
        return Colors.orange;
      case PropertyStatus.rejected:
        return AppColors.error;
      case PropertyStatus.draft:
        return AppColors.gray500;
    }
  }

  // Action Methods
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Properties'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter by status:'),
            const SizedBox(height: 12),
            ...PropertyStatus.values.map((status) {
              return RadioListTile<PropertyStatus?>(
                title: Text(status.name.capitalize()),
                value: status,
                groupValue: _statusFilter,
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            RadioListTile<PropertyStatus?>(
              title: const Text('All'),
              value: null,
              groupValue: _statusFilter,
              onChanged: (value) {
                setState(() {
                  _statusFilter = value;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _approveProperty(DemoProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Property'),
        content: Text('Are you sure you want to approve "${property.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${property.title} has been approved'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectProperty(DemoProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Property'),
        content: Text('Are you sure you want to reject "${property.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${property.title} has been rejected'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _viewPropertyDetails(DemoProperty property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing details for ${property.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editProperty(DemoProperty property) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${property.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
