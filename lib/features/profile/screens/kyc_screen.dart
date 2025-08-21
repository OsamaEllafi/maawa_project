import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/gradient_button.dart';

enum KycStatus { pending, verified, rejected }

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _ibanController = TextEditingController();

  KycStatus _currentStatus = KycStatus.pending;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _idNumberController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  Future<void> _submitKyc() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStatus = KycStatus.pending;
        });

        HapticFeedback.lightImpact();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('KYC documents submitted successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildStatusPill(KycStatus status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (status) {
      case KycStatus.pending:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        icon = Icons.schedule;
        text = 'Pending Review';
        break;
      case KycStatus.verified:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        icon = Icons.verified;
        text = 'Verified';
        break;
      case KycStatus.rejected:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        icon = Icons.cancel;
        text = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gray700),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'KYC Verification',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth < 400 ? 18 : 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildStatusPill(_currentStatus),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Identity Verification',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth < 400 ? 24 : 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide your identity information to verify your account.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.gray600,
                    fontSize: screenWidth < 400 ? 14 : 16,
                  ),
                ),

                const SizedBox(height: 32),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name (as on ID)',
                    hintText: 'Enter your full legal name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ID Number
                TextFormField(
                  controller: _idNumberController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'National ID Number',
                    hintText: 'Enter your national ID number',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your ID number';
                    }
                    if (value.trim().length < 8) {
                      return 'Please enter a valid ID number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // IBAN
                TextFormField(
                  controller: _ibanController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'IBAN Number',
                    hintText: 'LY83 0021 0000 0123 4567 8901',
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your IBAN';
                    }
                    final cleanIban = value.replaceAll(' ', '').toUpperCase();
                    if (!cleanIban.startsWith('LY') || cleanIban.length != 25) {
                      return 'Please enter a valid Libyan IBAN';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Information Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCoral.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryCoral.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryCoral,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Important Information',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryCoral,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• Ensure all information matches your official documents\n'
                        '• Your IBAN will be used for payments and refunds\n'
                        '• Verification typically takes 1-2 business days\n'
                        '• You\'ll receive an email once verification is complete',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.gray700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Submit Button
                if (_currentStatus != KycStatus.verified)
                  GradientButton(
                    text: _currentStatus == KycStatus.pending
                        ? 'Update Information'
                        : 'Submit for Verification',
                    isLoading: _isLoading,
                    onPressed: _submitKyc,
                    width: double.infinity,
                  ),

                // Status Messages
                if (_currentStatus == KycStatus.verified) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          color: Colors.green,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Account Verified!',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your account has been successfully verified. You can now access all features.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else if (_currentStatus == KycStatus.rejected) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Verification Failed',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'There was an issue with your submitted information. Please review and resubmit.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray700),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
