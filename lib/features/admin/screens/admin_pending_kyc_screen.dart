import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/user/entities/user.dart';

class AdminPendingKYCScreen extends StatefulWidget {
  const AdminPendingKYCScreen({super.key});

  @override
  State<AdminPendingKYCScreen> createState() => _AdminPendingKYCScreenState();
}

class _AdminPendingKYCScreenState extends State<AdminPendingKYCScreen> {
  bool _isLoading = false;
  List<User> _pendingKYCUsers = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPendingKYCUsers();
  }

  Future<void> _loadPendingKYCUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get all users and filter those with pending KYC
      final allUsers = await ServiceLocator().userRepository.getUsers();
      // Filter users who have KYC data but it's not verified yet
      final pendingUsers = allUsers
          .where(
            (user) => user.hasKYC && user.kyc != null && !user.kyc!.isVerified,
          )
          .toList();

      setState(() {
        _pendingKYCUsers = pendingUsers;
      });
      print('✅ Admin: Loaded ${pendingUsers.length} users with pending KYC');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('❌ Admin: Error loading pending KYC users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyKYC(String userUuid) async {
    final notes = await _showVerifyDialog();
    if (notes != null) {
      try {
        await ServiceLocator().adminRepository.verifyKYC(userUuid, notes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('KYC verified successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadPendingKYCUsers(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error verifying KYC: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _rejectKYC(String userUuid) async {
    final notes = await _showRejectDialog();
    if (notes != null && notes.isNotEmpty) {
      try {
        await ServiceLocator().adminRepository.rejectKYC(userUuid, notes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('KYC rejected successfully'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _loadPendingKYCUsers(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error rejecting KYC: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<String?> _showVerifyDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify KYC'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add verification notes (optional):'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter verification notes...',
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Verify', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<String?> _showRejectDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject KYC'),
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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? AppColors.gray300 : AppColors.gray700),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Pending KYC Verification',
          style: TextStyle(
            color: isDark ? AppColors.gray100 : AppColors.gray900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadPendingKYCUsers,
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
              'Error Loading KYC Data',
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
              onPressed: _loadPendingKYCUsers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_pendingKYCUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 64,
              color: Colors.green[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No Pending KYC Verifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.gray100 : AppColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All KYC submissions have been reviewed',
              style: TextStyle(color: AppColors.gray600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingKYCUsers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingKYCUsers.length,
        itemBuilder: (context, index) {
          final user = _pendingKYCUsers[index];
          return _buildKYCCard(user);
        },
      ),
    );
  }

  Widget _buildKYCCard(User user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kyc = user.kyc!;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryCoral.withValues(
                    alpha: 0.1,
                  ),
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null
                      ? Icon(Icons.person, color: AppColors.primaryCoral)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.gray100 : AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
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

            // KYC details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildKYCDetailRow('Full Name', kyc.fullName),
                  const SizedBox(height: 8),
                  _buildKYCDetailRow('ID Number', kyc.idNumber),
                  const SizedBox(height: 8),
                  _buildKYCDetailRow('IBAN', kyc.iban),
                  const SizedBox(height: 8),
                  _buildKYCDetailRow('Submitted', _formatDate(kyc.createdAt)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // User role and status
            Row(
              children: [
                _buildStatusChip(
                  label: user.role.toString().split('.').last.toUpperCase(),
                  color: _getRoleColor(user.role),
                ),
                const SizedBox(width: 8),
                _buildStatusChip(
                  label: user.status.toString().split('.').last.toUpperCase(),
                  color: _getStatusColor(user.status),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectKYC(user.uuid),
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
                    onPressed: () => _verifyKYC(user.uuid),
                    icon: const Icon(Icons.verified_user, color: Colors.white),
                    label: const Text(
                      'Verify',
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

  Widget _buildKYCDetailRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.gray100 : AppColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.purple;
      case UserRole.owner:
        return Colors.blue;
      case UserRole.tenant:
        return Colors.green;
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return Colors.green;
      case UserStatus.locked:
        return Colors.red;
      case UserStatus.pending:
        return Colors.orange;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
