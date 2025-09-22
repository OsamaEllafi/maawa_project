import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/properties/entities/property.dart';

class AdminPendingPropertiesScreen extends StatefulWidget {
  const AdminPendingPropertiesScreen({super.key});

  @override
  State<AdminPendingPropertiesScreen> createState() =>
      _AdminPendingPropertiesScreenState();
}

class _AdminPendingPropertiesScreenState
    extends State<AdminPendingPropertiesScreen> {
  bool _isLoading = false;
  List<Property> _pendingProperties = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPendingProperties();
  }

  Future<void> _loadPendingProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final properties = await ServiceLocator().adminRepository
          .getPendingProperties();
      setState(() {
        _pendingProperties = properties;
      });
      print('✅ Admin: Loaded ${properties.length} pending properties');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('❌ Admin: Error loading pending properties: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _approveProperty(String propertyUuid) async {
    try {
      await ServiceLocator().adminRepository.approveProperty(propertyUuid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Property approved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _loadPendingProperties(); // Reload the list
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error approving property: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectProperty(String propertyUuid) async {
    final reason = await _showRejectDialog();
    if (reason != null && reason.isNotEmpty) {
      try {
        await ServiceLocator().adminRepository.rejectProperty(
          propertyUuid,
          reason,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Property rejected successfully'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _loadPendingProperties(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error rejecting property: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<String?> _showRejectDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Property'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter reason for rejection...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.gray300 : AppColors.gray700,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Pending Properties',
          style: TextStyle(
            color: isDark ? AppColors.gray100 : AppColors.gray900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadPendingProperties,
            icon: Icon(Icons.refresh, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Properties',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.gray100 : AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPendingProperties,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_pendingProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No Pending Properties',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.gray100 : AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All properties have been reviewed',
              style: TextStyle(color: AppColors.gray600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingProperties,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingProperties.length,
        itemBuilder: (context, index) {
          final property = _pendingProperties[index];
          return _buildPropertyCard(property);
        },
      ),
    );
  }

  Widget _buildPropertyCard(Property property) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.gray100 : AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.address,
                        style: TextStyle(
                          color: AppColors.gray600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PENDING',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Property details
            Row(
              children: [
                _buildDetailChip(
                  icon: Icons.people,
                  label: '${property.capacity} guests',
                  color: AppColors.primaryCoral,
                ),
                const SizedBox(width: 8),
                _buildDetailChip(
                  icon: Icons.home,
                  label: property.type.toString().split('.').last.toUpperCase(),
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildDetailChip(
                  icon: Icons.star,
                  label: property.hasRating
                      ? property.ratingDisplay
                      : 'No reviews',
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Price
            Text(
              'LYD ${property.pricePerNight.toStringAsFixed(2)} / night',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryCoral,
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectProperty(property.uuid),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveProperty(property.uuid),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      'Approve',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
