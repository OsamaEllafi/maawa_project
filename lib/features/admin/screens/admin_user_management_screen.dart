import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/user/entities/user.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  bool _isLoading = false;
  List<User> _users = [];
  String? _error;
  String _searchQuery = '';
  UserRole? _selectedRole;
  UserStatus? _selectedStatus;

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final users = await ServiceLocator().userRepository.getUsers(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        role: _selectedRole?.toString().split('.').last,
        status: _selectedStatus?.toString().split('.').last,
      );
      setState(() {
        _users = users;
      });
      print('✅ Admin: Loaded ${users.length} users');
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      print('❌ Admin: Error loading users: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _promoteToOwner(String userUuid) async {
    final confirmed = await _showConfirmDialog(
      title: 'Promote to Owner',
      message: 'Are you sure you want to promote this user to Owner?',
    );

    if (confirmed) {
      try {
        await ServiceLocator().adminRepository.promoteToOwner(userUuid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User promoted to Owner successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadUsers(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error promoting user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _demoteToTenant(String userUuid) async {
    final confirmed = await _showConfirmDialog(
      title: 'Demote to Tenant',
      message: 'Are you sure you want to demote this user to Tenant?',
    );

    if (confirmed) {
      try {
        await ServiceLocator().adminRepository.demoteToTenant(userUuid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User demoted to Tenant successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadUsers(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error demoting user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _lockUser(String userUuid) async {
    final reason = await _showReasonDialog(
      title: 'Lock User',
      message: 'Please provide a reason for locking this user:',
      hintText: 'Enter reason for locking...',
    );

    if (reason != null && reason.isNotEmpty) {
      try {
        await ServiceLocator().adminRepository.lockUser(userUuid, reason);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User locked successfully'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _loadUsers(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error locking user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _unlockUser(String userUuid) async {
    final confirmed = await _showConfirmDialog(
      title: 'Unlock User',
      message: 'Are you sure you want to unlock this user?',
    );

    if (confirmed) {
      try {
        await ServiceLocator().adminRepository.unlockUser(userUuid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User unlocked successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadUsers(); // Reload the list
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error unlocking user: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<bool> _showConfirmDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoral,
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<String?> _showReasonDialog({
    required String title,
    required String message,
    required String hintText,
  }) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
            ),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    _searchQuery = _searchController.text;
    _loadUsers();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedRole = null;
      _selectedStatus = null;
    });
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.getGray700(context)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'User Management',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadUsers,
            icon: Icon(Icons.refresh, color: AppColors.primaryCoral),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: ThemeColors.getAppBarBackground(context),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search users by name or email...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: _applyFilters,
                icon: const Icon(Icons.search),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (_) => _applyFilters(),
          ),
          const SizedBox(height: 12),

          // Filter chips
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<UserRole?>(
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<UserRole?>(
                      value: null,
                      child: Text('All Roles'),
                    ),
                    ...UserRole.values.map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(
                          role.toString().split('.').last.toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedRole = value);
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<UserStatus?>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<UserStatus?>(
                      value: null,
                      child: Text('All Status'),
                    ),
                    ...UserStatus.values.map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(
                          status.toString().split('.').last.toUpperCase(),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedStatus = value);
                    _applyFilters();
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _clearFilters,
                icon: const Icon(Icons.clear),
                tooltip: 'Clear Filters',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
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
              'Error Loading Users',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.gray600),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: AppColors.gray400),
            const SizedBox(height: 16),
            Text(
              'No Users Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeColors.getTextPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search filters',
              style: TextStyle(color: AppColors.gray600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return _buildUserCard(user);
        },
      ),
    );
  }

  Widget _buildUserCard(User user) {
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
                  radius: 28,
                  backgroundColor: AppColors.primaryCoral.withValues(
                    alpha: 0.1,
                  ),
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null
                      ? Icon(
                          Icons.person,
                          color: AppColors.primaryCoral,
                          size: 28,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.getTextPrimary(context),
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStatusChip(
                            label: user.role
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            color: _getRoleColor(user.role),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusChip(
                            label: user.status
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            color: _getStatusColor(user.status),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // User info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Joined', _formatDate(user.createdAt)),
                  const SizedBox(height: 8),
                  _buildInfoRow('Last Updated', _formatDate(user.updatedAt)),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Email Verified',
                    user.isEmailVerified ? 'Yes' : 'No',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'KYC Status',
                    user.hasKYC ? 'Submitted' : 'Not Submitted',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons (only show if not admin)
            if (user.role != UserRole.admin) ...[
              Row(
                children: [
                  if (user.role == UserRole.tenant)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _promoteToOwner(user.uuid),
                        icon: const Icon(Icons.arrow_upward, size: 16),
                        label: const Text('Promote to Owner'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  if (user.role == UserRole.owner) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _demoteToTenant(user.uuid),
                        icon: const Icon(Icons.arrow_downward, size: 16),
                        label: const Text('Demote to Tenant'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                  if (user.role != UserRole.admin) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: user.isLocked
                          ? ElevatedButton.icon(
                              onPressed: () => _unlockUser(user.uuid),
                              icon: const Icon(Icons.lock_open, size: 16),
                              label: const Text('Unlock'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => _lockUser(user.uuid),
                              icon: const Icon(Icons.lock, size: 16),
                              label: const Text('Lock'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Colors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Administrator - No actions available',
                      style: TextStyle(
                        color: Colors.purple[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: ThemeColors.getTextPrimary(context),
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
