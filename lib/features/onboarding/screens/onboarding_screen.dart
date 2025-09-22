import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/branding/brand_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _iconController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late AnimationController _backgroundController;
  late AnimationController _particlesController;

  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotateAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particlesAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.search_rounded,
      title: 'Discover Amazing Properties',
      subtitle:
          'Browse through thousands of verified properties across Libya with detailed information and stunning photos.',
      gradient: [AppColors.primaryCoral, AppColors.primaryMagenta],
    ),
    OnboardingPage(
      icon: Icons.verified_user_rounded,
      title: 'Safe & Secure Booking',
      subtitle:
          'Book with confidence knowing all properties are verified and your payments are protected through our secure platform.',
      gradient: [AppColors.primaryTurquoise, AppColors.info],
    ),
    OnboardingPage(
      icon: Icons.support_agent_rounded,
      title: '24/7 Customer Support',
      subtitle:
          'Get help whenever you need it with our dedicated support team available around the clock.',
      gradient: [AppColors.primaryOrange, AppColors.primaryCoral],
    ),
    OnboardingPage(
      icon: Icons.home_work_rounded,
      title: 'Your Perfect Stay Awaits',
      subtitle:
          'Join thousands of satisfied users who found their ideal accommodation through MAAWA.',
      gradient: [AppColors.primaryMagenta, AppColors.primaryTurquoise],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _iconScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _iconRotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    _textSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _particlesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particlesController, curve: Curves.linear),
    );

    _startPageAnimations();
  }

  void _startPageAnimations() {
    _backgroundController.repeat(reverse: true);
    _particlesController.repeat();
    _iconController.forward();
    _textController.forward();
    _buttonController.forward();
  }

  void _resetAnimations() {
    _iconController.reset();
    _textController.reset();
    _buttonController.reset();
    _startPageAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _iconController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _backgroundController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  void _skipToLogin() {
    HapticFeedback.lightImpact();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _resetAnimations();
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _buildOnboardingPage(
                page,
                index,
                isDarkMode,
                screenWidth,
                screenHeight,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(
    OnboardingPage page,
    int index,
    bool isDarkMode,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: page.gradient,
        ),
      ),
      child: Stack(
        children: [
          // Animated background particles
          _buildParticles(isDarkMode),

          // Animated gradient overlay
          _buildGradientOverlay(page.gradient),

          // Main content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: 32,
              ),
              child: Column(
                children: [
                  // Skip button
                  if (index < _pages.length - 1)
                    _buildSkipButton(screenWidth)
                  else
                    const SizedBox(height: 48),

                  SizedBox(height: screenHeight * 0.06),

                  // Icon and illustration
                  _buildIconSection(page, screenWidth),

                  SizedBox(height: screenHeight * 0.05),

                  // Title and subtitle
                  _buildTextSection(page, screenWidth),

                  const Spacer(),

                  // Page indicator
                  _buildPageIndicator(),

                  SizedBox(height: screenHeight * 0.04),

                  // Next/Get Started button
                  _buildActionButton(page, index, screenWidth),

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton(double screenWidth) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedBuilder(
        animation: _textFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _textFadeAnimation.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: TextButton(
                  onPressed: _skipToLogin,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth < 400 ? 14 : 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconSection(OnboardingPage page, double screenWidth) {
    return AnimatedBuilder(
      animation: _iconController,
      builder: (context, child) {
        return Transform.scale(
          scale: _iconScaleAnimation.value,
          child: Transform.rotate(
            angle: _iconRotateAnimation.value,
            child: Container(
              width: screenWidth < 400 ? 120 : 140,
              height: screenWidth < 400 ? 120 : 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Icon(
                page.icon,
                size: screenWidth < 400 ? 60 : 70,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextSection(OnboardingPage page, double screenWidth) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _textSlideAnimation.value),
            child: Column(
              children: [
                // Title
                Text(
                  page.title,
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  page.subtitle,
                  style: TextStyle(
                    fontSize: screenWidth < 400 ? 16 : 18,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator() {
    return AnimatedBuilder(
      animation: _textFadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _textFadeAnimation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (dotIndex) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentPage == dotIndex ? 32 : 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _currentPage == dotIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: _currentPage == dotIndex
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    OnboardingPage page,
    int index,
    double screenWidth,
  ) {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnimation.value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _nextPage,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        index == _pages.length - 1 ? 'Get Started' : 'Next',
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: page.gradient[0],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        index == _pages.length - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: page.gradient[0],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticles(bool isDarkMode) {
    return AnimatedBuilder(
      animation: _particlesAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: OnboardingParticlesPainter(
            animation: _particlesAnimation.value,
            isDarkMode: isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay(List<Color> gradient) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                gradient[0].withOpacity(0.1 * _backgroundAnimation.value),
                gradient[1].withOpacity(0.1 * _backgroundAnimation.value),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

// Custom painter for onboarding particles
class OnboardingParticlesPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;

  OnboardingParticlesPainter({
    required this.animation,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 15; i++) {
      final x = (i * 47) % size.width;
      final y = (i * 83 + animation * 150) % size.height;
      final radius = 1.5 + (i % 2) * 1.0;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(OnboardingParticlesPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
