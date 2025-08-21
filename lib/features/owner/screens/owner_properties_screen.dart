import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../demo/demo_data.dart';
import '../../../demo/models.dart';
import 'package:go_router/go_router.dart';

class OwnerPropertiesScreen extends StatefulWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen> {
  String _selectedStatus = 'All';
  final List<String> _statusFilters = ['All', 'Published', 'Pending', 'Draft', 'Rejected'];
  String _sortBy = 'Newest';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final properties = _getFilteredProperties();

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        title: Text(
          'My Properties',
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
              Icons.add,
              color: ThemeColors.getGray700(context),
            ),
            onPressed: () => _showAddPropertyDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters and Sort
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: ThemeColors.getSurface(context),
              border: Border(
                bottom: BorderSide(
                  color: ThemeColors.getBorder(context),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Status Filter
                _buildStatusFilter(),
                const SizedBox(height: 16),
                // Sort Options
                Row(
                  children: [
                    Text(
                      'Sort by: ',
                      style: TextStyle(
                        color: ThemeColors.getGray600(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSortDropdown(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Properties List
          Expanded(
            child: properties.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: 16,
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPropertyCard(property),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _statusFilters.length,
        itemBuilder: (context, index) {
          final status = _statusFilters[index];
          final isSelected = _selectedStatus == status;
          
          return Padding(
            padding: EdgeInsets.only(right: index < _statusFilters.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedStatus = status),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryCoral
                      : ThemeColors.getGray50(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryCoral
                        : ThemeColors.getBorder(context),
                  ),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeColors.getGray50(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.getBorder(context)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: ThemeColors.getGray600(context)),
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontSize: 14,
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() => _sortBy = value);
            }
          },
          items: [
            'Newest',
            'Oldest',
            'Price: High to Low',
            'Price: Low to High',
            'Rating: High to Low',
            'Name: A to Z',
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  property.images.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(property.status).withValues(alpha: 0.9),
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
              // Quick Actions
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    _buildQuickActionButton(
                      Icons.edit,
                      'Edit',
                      () => _handlePropertyAction('edit', property),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionButton(
                      Icons.more_vert,
                      'More',
                      () => _showPropertyMenu(property),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    _buildPropertyDetail(Icons.bathtub, '${property.bathrooms}'),
                    const SizedBox(width: 16),
                    _buildPropertyDetail(Icons.people, '${property.capacity}'),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          property.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _handlePropertyAction('view', property),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryCoral,
                          side: BorderSide(color: AppColors.primaryCoral),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handlePropertyAction('bookings', property),
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: const Text('Bookings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCoral,
                          foregroundColor: Colors.white,
                        ),
                      ),
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

  Widget _buildQuickActionButton(IconData icon, String tooltip, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: ThemeColors.getGray700(context)),
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
            'Add your first property to start earning',
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
    var properties = DemoData.properties;
    
    // Filter by status
    if (_selectedStatus != 'All') {
      properties = properties.where((property) {
        return property.status.displayName == _selectedStatus;
      }).toList();
    }
    
    // Sort properties
    switch (_sortBy) {
      case 'Newest':
        properties.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest':
        properties.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Price: High to Low':
        properties.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        break;
      case 'Price: Low to High':
        properties.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case 'Rating: High to Low':
        properties.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Name: A to Z':
        properties.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    
    return properties;
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Edit ${property.title}')),
        );
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
    }
  }

  void _showPropertyMenu(DemoProperty property) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ThemeColors.getSurface(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeColors.getGray300(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              property.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildMenuOption(
              Icons.edit,
              'Edit Property',
              () {
                Navigator.pop(context);
                _handlePropertyAction('edit', property);
              },
            ),
            _buildMenuOption(
              Icons.visibility,
              'View Details',
              () {
                Navigator.pop(context);
                _handlePropertyAction('view', property);
              },
            ),
            _buildMenuOption(
              Icons.calendar_today,
              'View Bookings',
              () {
                Navigator.pop(context);
                _handlePropertyAction('bookings', property);
              },
            ),
            _buildMenuOption(
              Icons.analytics,
              'Analytics',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics coming soon!')),
                );
              },
            ),
            _buildMenuOption(
              Icons.delete,
              'Delete Property',
              () {
                Navigator.pop(context);
                _showDeleteConfirmation(property);
              },
              isDestructive: true,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : ThemeColors.getGray600(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : ThemeColors.getTextPrimary(context),
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(DemoProperty property) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text('Are you sure you want to delete "${property.title}"? This action cannot be undone.'),
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
