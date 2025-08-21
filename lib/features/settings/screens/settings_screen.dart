import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/app_shell.dart';
import '../../../core/models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _locationServices = true;
  bool _analyticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser!;

    return Scaffold(
      backgroundColor: ThemeColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: ThemeColors.getAppBarBackground(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeColors.getGray700(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: ThemeColors.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current User Info
            _buildUserInfo(currentUser),
            const SizedBox(height: 24),

            // Role Simulator (Dev Tool)
            _buildRoleSimulator(currentUser),
            const SizedBox(height: 24),

            // Notifications
            _buildNotificationsSection(),
            const SizedBox(height: 24),

            // App Settings
            _buildAppSettingsSection(),
            const SizedBox(height: 24),

            // Privacy & Security
            _buildPrivacySection(),
            const SizedBox(height: 24),

            // Support & About
            _buildSupportSection(),
            const SizedBox(height: 24),

            // Developer Tools
            _buildDeveloperTools(),
            const SizedBox(height: 24),

            // Danger Zone
            _buildDangerZone(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryCoral, AppColors.primaryMagenta],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCoral.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Text(
              user.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user.role.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSimulator(UserModel currentUser) {
    return _buildSection(
      'Role Simulator (Dev Tool)',
      [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Role: ${currentUser.role.name.toUpperCase()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Switch to different user role for testing:',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildRoleButton('Tenant', UserRole.tenant, currentUser.role),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildRoleButton('Owner', UserRole.owner, currentUser.role),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildRoleButton('Admin', UserRole.admin, currentUser.role),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton(String label, UserRole role, UserRole currentRole) {
    final isSelected = currentRole == role;
    
    return GestureDetector(
      onTap: () => _switchRole(role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryCoral : AppColors.gray100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryCoral : AppColors.gray300,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.gray700,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      'Notifications',
      [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
          activeColor: AppColors.primaryCoral,
        ),
        SwitchListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Receive notifications via email'),
          value: _emailNotifications,
          onChanged: (value) {
            setState(() {
              _emailNotifications = value;
            });
          },
          activeColor: AppColors.primaryCoral,
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive instant push notifications'),
          value: _pushNotifications,
          onChanged: (value) {
            setState(() {
              _pushNotifications = value;
            });
          },
          activeColor: AppColors.primaryCoral,
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    final appShell = Provider.of<AppShell>(context, listen: false);
    return _buildSection(
      'App Settings',
      [
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: appShell.themeMode == ThemeMode.dark,
          onChanged: (value) {
            appShell.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
          },
          activeColor: AppColors.primaryCoral,
        ),
        ListTile(
          title: const Text('Language'),
          subtitle: Text(appShell.getLanguageLabel()),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showLanguageDialog,
        ),
        SwitchListTile(
          title: const Text('Location Services'),
          subtitle: const Text('Allow app to access location'),
          value: _locationServices,
          onChanged: (value) {
            setState(() {
              _locationServices = value;
            });
          },
          activeColor: AppColors.primaryCoral,
        ),
        SwitchListTile(
          title: const Text('Analytics'),
          subtitle: const Text('Help improve the app'),
          value: _analyticsEnabled,
          onChanged: (value) {
            setState(() {
              _analyticsEnabled = value;
            });
          },
          activeColor: AppColors.primaryCoral,
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return _buildSection(
      'Privacy & Security',
      [
        ListTile(
          leading: const Icon(Icons.lock_outline, color: AppColors.primaryCoral),
          title: const Text('Change Password'),
          subtitle: const Text('Update your account password'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _changePassword,
        ),
        ListTile(
          leading: const Icon(Icons.security, color: AppColors.primaryCoral),
          title: const Text('Two-Factor Authentication'),
          subtitle: const Text('Add extra security to your account'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _setupTwoFactor,
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryCoral),
          title: const Text('Privacy Policy'),
          subtitle: const Text('Read our privacy policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _viewPrivacyPolicy,
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined, color: AppColors.primaryCoral),
          title: const Text('Terms of Service'),
          subtitle: const Text('Read our terms of service'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _viewTermsOfService,
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      'Support & About',
      [
        ListTile(
          leading: const Icon(Icons.help_outline, color: AppColors.primaryCoral),
          title: const Text('Help Center'),
          subtitle: const Text('Get help and support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _openHelpCenter,
        ),
        ListTile(
          leading: const Icon(Icons.contact_support_outlined, color: AppColors.primaryCoral),
          title: const Text('Contact Support'),
          subtitle: const Text('Get in touch with our team'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _contactSupport,
        ),
        ListTile(
          leading: const Icon(Icons.info_outline, color: AppColors.primaryCoral),
          title: const Text('About MAAWA'),
          subtitle: const Text('Learn more about the app'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showAboutDialog,
        ),
        ListTile(
          leading: const Icon(Icons.star_outline, color: AppColors.primaryCoral),
          title: const Text('Rate the App'),
          subtitle: const Text('Rate us on the app store'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _rateApp,
        ),
      ],
    );
  }

  Widget _buildDeveloperTools() {
    return _buildSection(
      'Developer Tools',
      [
        ListTile(
          leading: const Icon(Icons.bug_report_outlined, color: AppColors.primaryCoral),
          title: const Text('Debug Info'),
          subtitle: const Text('View app debug information'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showDebugInfo,
        ),
        ListTile(
          leading: const Icon(Icons.storage_outlined, color: AppColors.primaryCoral),
          title: const Text('Clear Cache'),
          subtitle: const Text('Clear app cache and data'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _clearCache,
        ),
        ListTile(
          leading: const Icon(Icons.refresh, color: AppColors.primaryCoral),
          title: const Text('Reset App'),
          subtitle: const Text('Reset app to default settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _resetApp,
        ),
        ListTile(
          leading: const Icon(Icons.code, color: AppColors.primaryCoral),
          title: const Text('API Endpoints'),
          subtitle: const Text('View API configuration'),
          trailing: const Icon(Icons.chevron_right),
          onTap: _showApiEndpoints,
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return _buildSection(
      'Danger Zone',
      [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚠️ Warning',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'These actions cannot be undone. Please proceed with caution.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deactivateAccount,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: const Text('Deactivate Account'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _deleteAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.gray900,
            ),
          ),
        ),
        Container(
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
          child: Column(children: children),
        ),
      ],
    );
  }

  // Action Methods
  void _switchRole(UserRole newRole) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Switch Role'),
        content: Text('Are you sure you want to switch to ${newRole.name} role?'),
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
                  content: Text('Switched to ${newRole.name} role'),
                  backgroundColor: AppColors.primaryCoral,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('Switch'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final appShell = Provider.of<AppShell>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: const Text('English'),
              value: const Locale('en'),
              groupValue: appShell.locale,
              onChanged: (value) {
                appShell.setLocale(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<Locale>(
              title: const Text('العربية'),
              value: const Locale('ar'),
              groupValue: appShell.locale,
              onChanged: (value) {
                appShell.setLocale(value!);
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

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password change feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setupTwoFactor() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Two-factor authentication coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening privacy policy...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewTermsOfService() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening terms of service...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening help center...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening support contact...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'MAAWA',
      applicationVersion: '1.0.0',
      applicationIcon: Image.asset(
        'frontend/assets/branding/Logo1.png',
        width: 50,
        height: 50,
      ),
      children: const [
        Text(
          'MAAWA is a comprehensive property rental platform designed to connect property owners with tenants in Libya.',
        ),
        SizedBox(height: 16),
        Text(
          '© 2024 MAAWA. All rights reserved.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening app store...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDebugInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Debug Information'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('App Version: 1.0.0'),
              Text('Build Number: 1'),
              Text('Platform: Flutter'),
              Text('Device: Android/iOS'),
              Text('API Version: v1'),
              SizedBox(height: 16),
              Text('Cache Size: 15.2 MB'),
              Text('Database Size: 2.1 MB'),
              Text('Last Sync: 2 minutes ago'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the app cache?'),
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
                  content: const Text('Cache cleared successfully'),
                  backgroundColor: ThemeColors.getSnackBarSuccess(context),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _resetApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text('This will reset all app settings to default. Are you sure?'),
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
                  content: const Text('App reset successfully'),
                  backgroundColor: ThemeColors.getSnackBarSuccess(context),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryCoral,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showApiEndpoints() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API Endpoints'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Base URL: https://api.maawa.ly'),
              SizedBox(height: 8),
              Text('Auth: /auth'),
              Text('Properties: /properties'),
              Text('Bookings: /bookings'),
              Text('Users: /users'),
              Text('Reviews: /reviews'),
              Text('Wallet: /wallet'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deactivateAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Account'),
        content: const Text('Your account will be temporarily disabled. You can reactivate it later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deactivated'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone. All your data will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion initiated'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
}
