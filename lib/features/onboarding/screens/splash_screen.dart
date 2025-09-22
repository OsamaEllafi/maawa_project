import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/branding/brand_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoScaleController;
  late AnimationController _logoFadeController;
  late AnimationController _logoRotateController;
  late AnimationController _backgroundController;
  late AnimationController _particlesController;
  late AnimationController _textFadeController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particlesAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize all animation controllers
    _logoScaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoFadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoRotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _textFadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Setup animations
    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoScaleController, curve: Curves.elasticOut),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoFadeController, curve: Curves.easeInOut),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _logoRotateController, curve: Curves.easeInOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _particlesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particlesController, curve: Curves.linear),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textFadeController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  _startAnimations() async {
    try {
      // Start background animation
      if (mounted) {
        _backgroundController.repeat(reverse: true);
      }

      // Start particles animation
      if (mounted) {
        _particlesController.repeat();
      }

      // Start logo fade in
      if (mounted) {
        _logoFadeController.forward();
      }

      // Start logo scale animation after a short delay
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        _logoScaleController.forward();
      }

      // Start logo rotation (subtle)
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _logoRotateController.repeat(reverse: true);
      }

      // Start text fade in
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _textFadeController.forward();
      }

      // Navigate after animations complete
      await Future.delayed(const Duration(milliseconds: 2500));
      if (mounted) {
        _navigateToNext();
      }
    } catch (e) {
      print('Splash screen animation error: $e');
      // If animations fail, just navigate
      if (mounted) {
        _navigateToNext();
      }
    }
  }

  _navigateToNext() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Check if user has a valid session
      final hasValidSession = await ServiceLocator().authRepository
          .hasValidSession();

      if (hasValidSession) {
        // User is authenticated, let the router handle the navigation
        if (mounted) {
          // Navigate to a route that will trigger the router's redirect logic
          context.go('/auth-check');
        }
      } else {
        // User is not authenticated, navigate to onboarding
        if (mounted) {
          context.go('/onboarding');
        }
      }
    } catch (e) {
      // If there's an error checking authentication, go to onboarding
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  void dispose() {
    _logoScaleController.dispose();
    _logoFadeController.dispose();
    _logoRotateController.dispose();
    _backgroundController.dispose();
    _particlesController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: _getBackgroundGradient(isDarkMode)),
        child: Stack(
          children: [
            // Animated background particles
            _buildParticles(isDarkMode),

            // Animated gradient overlay
            _buildGradientOverlay(isDarkMode),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animations
                  _buildAnimatedLogo(isDarkMode),

                  const SizedBox(height: 40),

                  // App name with fade animation
                  _buildAppName(isDarkMode),

                  const SizedBox(height: 16),

                  // Tagline with fade animation
                  _buildTagline(isDarkMode),

                  const SizedBox(height: 60),

                  // Version info
                  _buildVersionInfo(isDarkMode),
                ],
              ),
            ),

            // Floating elements
            _buildFloatingElements(isDarkMode),
          ],
        ),
      ),
    );
  }

  LinearGradient _getBackgroundGradient(bool isDarkMode) {
    if (isDarkMode) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        stops: [0.0, 0.5, 1.0],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF), Color(0xFFDEE2E6)],
        stops: [0.0, 0.5, 1.0],
      );
    }
  }

  Widget _buildParticles(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _particlesAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: ParticlesPainter(
            animation: _particlesAnimation.value,
            isDarkMode: isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryCoral.withOpacity(
                  0.1 * _backgroundAnimation.value,
                ),
                AppColors.primaryMagenta.withOpacity(
                  0.1 * _backgroundAnimation.value,
                ),
                AppColors.primaryTurquoise.withOpacity(
                  0.1 * _backgroundAnimation.value,
                ),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo(bool isDarkMode) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoScaleController,
        _logoFadeController,
        _logoRotateController,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotateAnimation.value,
            child: Opacity(
              opacity: _logoFadeAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryCoral.withOpacity(
                        isDarkMode ? 0.2 : 0.1,
                      ),
                      AppColors.primaryMagenta.withOpacity(
                        isDarkMode ? 0.2 : 0.1,
                      ),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCoral.withOpacity(
                        isDarkMode ? 0.3 : 0.2,
                      ),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: BrandLogo(
                  size: LogoSize.xxLarge,
                  theme: LogoTheme.primary,
                  showTagline: false,
                  animate: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
            child: Text(
              BrandConstants.appName,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : AppColors.gray900,
                letterSpacing: 2.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
            child: Text(
              BrandConstants.appTagline,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: isDarkMode
                    ? Colors.white.withOpacity(0.8)
                    : AppColors.gray700,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  Widget _buildVersionInfo(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value * 0.6,
          child: Text(
            'Version ${BrandConstants.appVersion}',
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.5)
                  : AppColors.gray600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _particlesAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating circles
            Positioned(
              top: 100,
              left: 50,
              child: _buildFloatingCircle(
                size: 20,
                color: AppColors.primaryCoral,
                delay: 0.0,
                isDarkMode: isDarkMode,
              ),
            ),
            Positioned(
              top: 200,
              right: 80,
              child: _buildFloatingCircle(
                size: 15,
                color: AppColors.primaryMagenta,
                delay: 0.3,
                isDarkMode: isDarkMode,
              ),
            ),
            Positioned(
              bottom: 150,
              left: 100,
              child: _buildFloatingCircle(
                size: 25,
                color: AppColors.primaryTurquoise,
                delay: 0.6,
                isDarkMode: isDarkMode,
              ),
            ),
            Positioned(
              bottom: 200,
              right: 60,
              child: _buildFloatingCircle(
                size: 18,
                color: AppColors.primaryOrange,
                delay: 0.9,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingCircle({
    required double size,
    required Color color,
    required double delay,
    required bool isDarkMode,
  }) {
    return AnimatedBuilder(
      animation: _particlesAnimation,
      builder: (context, child) {
        final animationValue = (_particlesAnimation.value + delay) % 1.0;
        final yOffset = 20 * (0.5 - (animationValue - 0.5).abs());
        final opacity = 0.3 + 0.4 * (0.5 - (animationValue - 0.5).abs());

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(isDarkMode ? 0.3 : 0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for background particles
class ParticlesPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;

  ParticlesPainter({required this.animation, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode
          ? Colors.white.withOpacity(0.1)
          : AppColors.gray600.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw multiple particles
    for (int i = 0; i < 20; i++) {
      final x = (i * 37) % size.width;
      final y = (i * 73 + animation * 100) % size.height;
      final radius = 2.0 + (i % 3) * 1.0;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
