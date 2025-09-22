import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/theme_toggle.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../domain/user/entities/user.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/di/service_locator.dart' show AuthProvider;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  UserRole _selectedRole = UserRole.tenant;

  // Field-specific error states
  String? _emailError;
  String? _passwordError;
  String? _nameError;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _clearFieldErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _nameError = null;
    });
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface.withValues(alpha: 0.95)
                      : AppColors.lightSurface.withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terms & Conditions',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please read carefully',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermsSection(
                          '1. Acceptance of Terms',
                          'By creating an account with MAAWA, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our services.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '2. User Responsibilities',
                          'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You must notify us immediately of any unauthorized use.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '3. Privacy Policy',
                          'Your privacy is important to us. Our Privacy Policy explains how we collect, use, and protect your personal information. By using our services, you consent to our Privacy Policy.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '4. Service Usage',
                          'MAAWA provides property rental and booking services. You agree to use these services only for lawful purposes and in accordance with these terms.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '5. Payment Terms',
                          'All payments must be made in full at the time of booking unless otherwise specified. We reserve the right to modify pricing at any time.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '6. Cancellation Policy',
                          'Cancellation policies vary by property. Please review the specific cancellation terms for each booking before confirming.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '7. Limitation of Liability',
                          'MAAWA is not liable for any indirect, incidental, special, or consequential damages arising from your use of our services.',
                        ),
                        const SizedBox(height: 20),
                        _buildTermsSection(
                          '8. Contact Information',
                          'For questions about these terms, please contact us at support@maawa.com or call +1-800-MAAWA.',
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.gray800.withValues(alpha: 0.5)
                        : AppColors.gray50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _acceptTerms = true;
                            });
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryCoral,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'I Agree',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTermsSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.gray200
                : AppColors.gray800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.gray400
                : AppColors.gray600,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      print('📝 RegisterScreen: Starting registration process...');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Clear any previous field errors
      _clearFieldErrors();

      try {
        print('📝 RegisterScreen: Calling authProvider.register...');
        await authProvider.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
          _confirmPasswordController.text,
        );

        print(
          '📝 RegisterScreen: Registration completed, isAuthenticated: ${authProvider.isAuthenticated}',
        );

        if (authProvider.isAuthenticated && mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Welcome to MAAWA, ${_nameController.text}!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );

          // Router will automatically redirect to the appropriate home page based on user role
        } else if (mounted) {
          print(
            '📝 RegisterScreen: Registration failed, error: ${authProvider.error}',
          );

          // Handle validation errors specifically
          if (authProvider.error != null) {
            _handleValidationErrors(authProvider.error!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text('Registration failed. Please try again.'),
                  ],
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        print('📝 RegisterScreen: Registration error - $e');
        if (mounted) {
          if (e is ValidationError) {
            _handleValidationErrors(e.message);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.toString())),
                  ],
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } else {
      print('📝 RegisterScreen: Form validation failed or terms not accepted');
    }
  }

  void _handleValidationErrors(String errorMessage) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if we have field-specific validation errors
    if (authProvider.validationError != null) {
      final validationError = authProvider.validationError!;

      // Set field-specific errors
      if (validationError.hasFieldError('email')) {
        final emailErrors = validationError.getFieldError('email');
        if (emailErrors != null && emailErrors.isNotEmpty) {
          setState(() {
            _emailError = emailErrors.first;
          });
        }
      }

      if (validationError.hasFieldError('password')) {
        final passwordErrors = validationError.getFieldError('password');
        if (passwordErrors != null && passwordErrors.isNotEmpty) {
          setState(() {
            _passwordError = passwordErrors.first;
          });
        }
      }

      if (validationError.hasFieldError('name')) {
        final nameErrors = validationError.getFieldError('name');
        if (nameErrors != null && nameErrors.isNotEmpty) {
          setState(() {
            _nameError = nameErrors.first;
          });
        }
      }
    } else {
      // Fallback to string parsing for backward compatibility
      if (errorMessage.contains('email') &&
          errorMessage.contains('already registered')) {
        setState(() {
          _emailError = 'This email is already registered.';
        });
      }

      if (errorMessage.contains('password') &&
          errorMessage.contains('at least 8 characters')) {
        setState(() {
          _passwordError = 'Password must be at least 8 characters.';
        });
      }
    }

    // Show general error message if no specific field errors were set
    if (_emailError == null && _passwordError == null && _nameError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(errorMessage)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (_emailError != null) {
      return _emailError;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (_passwordError != null) {
      return _passwordError;
    }
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkBackground,
                    AppColors.darkBackground.withValues(alpha: 0.8),
                    AppColors.darkSurface,
                  ]
                : [
                    AppColors.lightBackground,
                    AppColors.lightBackground.withValues(alpha: 0.9),
                    AppColors.lightSurface,
                  ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 24,
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Create Account',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 400 ? 24 : 28,
                            ),
                          ),
                        ),
                        // Theme Toggle
                        ThemeToggleButton(
                          size: 44,
                          showBackground: true,
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Welcome Section
                    Center(
                      child: Column(
                        children: [
                          // Logo with animated container
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryCoral.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'frontend/assets/branding/Logo1.png',
                              width: 80,
                              height: 80,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Join MAAWA Today',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth < 400 ? 24 : 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your account to start your journey',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: isDark
                                  ? AppColors.gray400
                                  : AppColors.gray600,
                              fontSize: screenWidth < 400 ? 14 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Registration Form Card
                    Container(
                      padding: EdgeInsets.all(screenWidth < 400 ? 20 : 32),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.3)
                                : AppColors.shadowLight,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Role Selection
                            Text(
                              'I want to:',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),

                            Wrap(
                              spacing: 20,
                              runSpacing: 12,
                              children: UserRole.values
                                  .where((role) => role != UserRole.admin)
                                  .map((role) {
                                    final isSelected = _selectedRole == role;
                                    return GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          _selectedRole = role;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? AppColors.primaryGradient
                                              : null,
                                          color: isSelected
                                              ? null
                                              : isDark
                                              ? AppColors.gray800
                                              : AppColors.gray50,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.transparent
                                                : isDark
                                                ? AppColors.gray700
                                                : AppColors.gray200,
                                            width: 1.5,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors
                                                        .primaryCoral
                                                        .withValues(alpha: 0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Text(
                                          role == UserRole.tenant
                                              ? 'Find Properties'
                                              : 'List Properties',
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : isDark
                                                ? AppColors.gray300
                                                : AppColors.gray700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),

                            SizedBox(height: screenWidth < 400 ? 24 : 32),

                            // Name Field
                            _buildFormField(
                              controller: _nameController,
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline,
                              errorText: _nameError,
                              validator: (value) {
                                if (_nameError != null) {
                                  return _nameError;
                                }
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your full name';
                                }
                                if (value.trim().length < 2) {
                                  return 'Name must be at least 2 characters';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  if (_nameError != null) {
                                    _nameError = null;
                                  }
                                });
                              },
                              isDark: isDark,
                            ),

                            SizedBox(height: screenWidth < 400 ? 16 : 20),

                            // Email Field
                            _buildFormField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'Enter your email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              errorText: _emailError,
                              validator: _validateEmail,
                              onChanged: (value) {
                                setState(() {
                                  if (_emailError != null) {
                                    _emailError = null;
                                  }
                                });
                              },
                              isDark: isDark,
                            ),

                            SizedBox(height: screenWidth < 400 ? 16 : 20),

                            // Password Field
                            _buildFormField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Enter your password (min 8 characters)',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              onTogglePassword: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              errorText: _passwordError,
                              validator: _validatePassword,
                              onChanged: (value) {
                                setState(() {
                                  if (_passwordError != null) {
                                    _passwordError = null;
                                  }
                                });
                              },
                              isDark: isDark,
                            ),

                            SizedBox(height: screenWidth < 400 ? 16 : 20),

                            // Confirm Password Field
                            _buildFormField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hint: 'Confirm your password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscureConfirmPassword,
                              onTogglePassword: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              validator: _validateConfirmPassword,
                              isDark: isDark,
                            ),

                            SizedBox(height: screenWidth < 400 ? 20 : 24),

                            // Terms and Conditions
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.gray800.withValues(alpha: 0.5)
                                    : AppColors.gray50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.gray700
                                      : AppColors.gray200,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (value) {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        _acceptTerms = value ?? false;
                                      });
                                    },
                                    activeColor: AppColors.primaryCoral,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _acceptTerms = !_acceptTerms;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: RichText(
                                          text: TextSpan(
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  fontSize: screenWidth < 400
                                                      ? 12
                                                      : 14,
                                                  color: isDark
                                                      ? AppColors.gray300
                                                      : AppColors.gray700,
                                                ),
                                            children: [
                                              const TextSpan(
                                                text: 'I agree to the ',
                                              ),
                                              WidgetSpan(
                                                child: GestureDetector(
                                                  onTap: _showTermsDialog,
                                                  child: Text(
                                                    'Terms & Conditions',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .primaryCoral,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const TextSpan(text: ' and '),
                                              WidgetSpan(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // TODO: Show Privacy Policy dialog
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Privacy Policy coming soon!',
                                                        ),
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Privacy Policy',
                                                    style: TextStyle(
                                                      color: AppColors
                                                          .primaryCoral,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenWidth < 400 ? 24 : 32),

                            // Register Button
                            GradientButton(
                              text: 'Create Account',
                              isLoading: authProvider.isLoading,
                              onPressed: _acceptTerms ? _handleRegister : null,
                              width: double.infinity,
                              height: 56,
                              borderRadius: BorderRadius.circular(16),
                              textStyle: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(height: screenWidth < 400 ? 20 : 24),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: isDark
                                        ? AppColors.gray700
                                        : AppColors.gray300,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'or',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? AppColors.gray400
                                          : AppColors.gray600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: isDark
                                        ? AppColors.gray700
                                        : AppColors.gray300,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenWidth < 400 ? 20 : 24),

                            // Social Register Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _buildGoogleButton(
                                    onPressed: () {
                                      // TODO: Implement Google registration
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildFacebookButton(
                                    onPressed: () {
                                      // TODO: Implement Facebook registration
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login Link
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/login'),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.gray400
                                  : AppColors.gray600,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: AppColors.primaryCoral,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
    String? errorText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyLarge,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: isDark ? AppColors.gray400 : AppColors.gray600,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: isDark ? AppColors.gray400 : AppColors.gray600,
                ),
                onPressed: onTogglePassword,
              )
            : controller.text.isNotEmpty
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        filled: true,
        fillColor: isDark
            ? AppColors.gray800.withValues(alpha: 0.5)
            : AppColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primaryCoral, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        errorText: errorText,
      ),
      validator: validator,
    );
  }

  Widget _buildGoogleButton({required VoidCallback onPressed}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF34A853)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4285F4).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Google icon with better design
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Google',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFacebookButton({required VoidCallback onPressed}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1877F2), Color(0xFF166FE5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1877F2).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.facebook, size: 20, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Facebook',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
