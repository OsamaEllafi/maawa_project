import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/config/app_config.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  Environment _selectedEnvironment = AppConfig.currentEnvironment;
  bool _maintenanceMode = false;
  bool _registrationEnabled = true;
  bool _emailVerificationRequired = true;
  bool _kycRequired = true;
  double _platformCommission = 5.0;
  int _maxPropertiesPerOwner = 10;

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
          'Admin Settings',
          style: TextStyle(
            color: isDark ? AppColors.gray100 : AppColors.gray900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSystemSettingsSection(),
            const SizedBox(height: 24),
            _buildPlatformSettingsSection(),
            const SizedBox(height: 24),
            _buildSecuritySettingsSection(),
            const SizedBox(height: 24),
            _buildBusinessSettingsSection(),
            const SizedBox(height: 24),
            _buildSystemInfoSection(),
            const SizedBox(height: 24),
            _buildDangerZoneSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemSettingsSection() {
    return _buildSection(
      title: 'System Settings',
      icon: Icons.settings,
      color: AppColors.primaryCoral,
      children: [
        // Environment Configuration
        ListTile(
          leading: Icon(Icons.cloud, color: AppColors.primaryCoral),
          title: const Text('Environment'),
          subtitle: Text(
            'Current: ${AppConfig.getEnvironmentName(_selectedEnvironment)}',
          ),
          trailing: DropdownButton<Environment>(
            value: _selectedEnvironment,
            items: AppConfig.availableEnvironments.map((env) {
              return DropdownMenuItem(
                value: env,
                child: Text(AppConfig.getEnvironmentName(env)),
              );
            }).toList(),
            onChanged: (Environment? newValue) async {
              if (newValue != null) {
                setState(() {
                  _selectedEnvironment = newValue;
                });
                await AppConfig.setEnvironment(newValue);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Environment changed to ${AppConfig.getEnvironmentName(newValue)}. Please restart the app.',
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),

        // Maintenance Mode
        SwitchListTile(
          secondary: Icon(Icons.build, color: Colors.orange),
          title: const Text('Maintenance Mode'),
          subtitle: const Text('Enable to prevent new user activities'),
          value: _maintenanceMode,
          onChanged: (bool value) {
            setState(() {
              _maintenanceMode = value;
            });
            _showMaintenanceModeDialog(value);
          },
        ),

        // Debug Mode Info
        ListTile(
          leading: Icon(Icons.bug_report, color: Colors.purple),
          title: const Text('Debug Mode'),
          subtitle: Text(AppConfig.isDebug ? 'Enabled' : 'Disabled'),
          trailing: Icon(
            AppConfig.isDebug ? Icons.check_circle : Icons.cancel,
            color: AppConfig.isDebug ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformSettingsSection() {
    return _buildSection(
      title: 'Platform Settings',
      icon: Icons.business,
      color: Colors.blue,
      children: [
        // Registration Settings
        SwitchListTile(
          secondary: Icon(Icons.person_add, color: Colors.blue),
          title: const Text('User Registration'),
          subtitle: const Text('Allow new users to register'),
          value: _registrationEnabled,
          onChanged: (bool value) {
            setState(() {
              _registrationEnabled = value;
            });
          },
        ),

        // Email Verification
        SwitchListTile(
          secondary: Icon(Icons.email, color: Colors.green),
          title: const Text('Email Verification'),
          subtitle: const Text('Require email verification for new users'),
          value: _emailVerificationRequired,
          onChanged: (bool value) {
            setState(() {
              _emailVerificationRequired = value;
            });
          },
        ),

        // KYC Requirement
        SwitchListTile(
          secondary: Icon(Icons.verified_user, color: Colors.purple),
          title: const Text('KYC Verification'),
          subtitle: const Text('Require KYC for property owners'),
          value: _kycRequired,
          onChanged: (bool value) {
            setState(() {
              _kycRequired = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildBusinessSettingsSection() {
    return _buildSection(
      title: 'Business Settings',
      icon: Icons.attach_money,
      color: Colors.green,
      children: [
        // Platform Commission
        ListTile(
          leading: Icon(Icons.percent, color: Colors.green),
          title: const Text('Platform Commission'),
          subtitle: Text(
            '${_platformCommission.toStringAsFixed(1)}% per booking',
          ),
          trailing: SizedBox(
            width: 100,
            child: Slider(
              value: _platformCommission,
              min: 0.0,
              max: 20.0,
              divisions: 40,
              onChanged: (double value) {
                setState(() {
                  _platformCommission = value;
                });
              },
            ),
          ),
        ),

        // Max Properties Per Owner
        ListTile(
          leading: Icon(Icons.home_max, color: Colors.orange),
          title: const Text('Max Properties Per Owner'),
          subtitle: Text('$_maxPropertiesPerOwner properties'),
          trailing: SizedBox(
            width: 100,
            child: Slider(
              value: _maxPropertiesPerOwner.toDouble(),
              min: 1.0,
              max: 50.0,
              divisions: 49,
              onChanged: (double value) {
                setState(() {
                  _maxPropertiesPerOwner = value.round();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySettingsSection() {
    return _buildSection(
      title: 'Security Settings',
      icon: Icons.security,
      color: Colors.red,
      children: [
        ListTile(
          leading: Icon(Icons.vpn_key, color: Colors.red),
          title: const Text('API Keys Management'),
          subtitle: const Text('Manage external service API keys'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('API Keys management coming soon')),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.history, color: Colors.blue),
          title: const Text('Audit Logs'),
          subtitle: const Text('View system audit logs'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Audit logs coming soon')),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.backup, color: Colors.green),
          title: const Text('Database Backup'),
          subtitle: const Text('Create system backup'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            _showBackupDialog();
          },
        ),
      ],
    );
  }

  Widget _buildSystemInfoSection() {
    return _buildSection(
      title: 'System Information',
      icon: Icons.info,
      color: AppColors.gray600,
      children: [
        ListTile(
          leading: Icon(Icons.code, color: AppColors.gray600),
          title: const Text('App Version'),
          subtitle: const Text('2.0.0'),
        ),

        ListTile(
          leading: Icon(Icons.api, color: AppColors.gray600),
          title: const Text('API Base URL'),
          subtitle: Text(AppConfig.apiBaseUrl),
        ),

        ListTile(
          leading: Icon(
            Icons.build_circle,
            color: AppConfig.isDebug ? Colors.orange : Colors.green,
          ),
          title: const Text('Build Type'),
          subtitle: Text(AppConfig.isDebug ? 'Debug' : 'Release'),
        ),
      ],
    );
  }

  Widget _buildDangerZoneSection() {
    return _buildSection(
      title: 'Danger Zone',
      icon: Icons.warning,
      color: Colors.red,
      children: [
        ListTile(
          leading: Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Clear System Cache'),
          subtitle: const Text('Clear all cached data'),
          trailing: ElevatedButton(
            onPressed: _clearSystemCache,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ),

        ListTile(
          leading: Icon(Icons.restart_alt, color: Colors.orange),
          title: const Text('Reset Settings'),
          subtitle: const Text('Reset all settings to default'),
          trailing: ElevatedButton(
            onPressed: _resetSettings,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _showMaintenanceModeDialog(bool enable) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          enable ? 'Enable Maintenance Mode' : 'Disable Maintenance Mode',
        ),
        content: Text(
          enable
              ? 'This will prevent users from accessing the platform. Are you sure?'
              : 'Users will be able to access the platform again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _maintenanceMode = !enable;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    enable
                        ? 'Maintenance mode enabled'
                        : 'Maintenance mode disabled',
                  ),
                  backgroundColor: enable ? Colors.orange : Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: enable ? Colors.orange : Colors.green,
            ),
            child: Text(
              enable ? 'Enable' : 'Disable',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Backup'),
        content: const Text(
          'This will create a backup of the current database. This operation may take a few minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Simulate backup process
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text(
              'Create Backup',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _clearSystemCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear System Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('System cache cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text(
          'This will reset all settings to their default values. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _maintenanceMode = false;
                _registrationEnabled = true;
                _emailVerificationRequired = true;
                _kycRequired = true;
                _platformCommission = 5.0;
                _maxPropertiesPerOwner = 10;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to default'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
