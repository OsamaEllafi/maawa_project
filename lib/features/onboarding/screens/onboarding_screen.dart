import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.search,
      title: 'Discover Amazing Properties',
      subtitle:
          'Browse through thousands of verified properties across Libya with detailed information and stunning photos.',
      backgroundColor: AppColors.primaryCoral,
    ),
    OnboardingPage(
      icon: Icons.verified_user,
      title: 'Safe & Secure Booking',
      subtitle:
          'Book with confidence knowing all properties are verified and your payments are protected through our secure platform.',
      backgroundColor: AppColors.primaryTurquoise,
    ),
    OnboardingPage(
      icon: Icons.support_agent,
      title: '24/7 Customer Support',
      subtitle:
          'Get help whenever you need it with our dedicated support team available around the clock.',
      backgroundColor: AppColors.primaryTurquoise,
    ),
    OnboardingPage(
      icon: Icons.home_work,
      title: 'Your Perfect Stay Awaits',
      subtitle:
          'Join thousands of satisfied users who found their ideal accommodation through MAAWA.',
      backgroundColor: AppColors.primaryCoral,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      page.backgroundColor,
                      page.backgroundColor.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        // Skip button
                        if (index < _pages.length - 1)
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: _skipToLogin,
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth < 400 ? 14 : 16,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 48),

                        SizedBox(height: screenHeight * 0.08),

                        // Icon
                        Container(
                          width: screenWidth < 400 ? 120 : 140,
                          height: screenWidth < 400 ? 120 : 140,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            size: screenWidth < 400 ? 60 : 70,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // Title
                        Text(
                          page.title,
                          style: TextStyle(
                            fontSize: screenWidth < 400 ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Subtitle
                        Text(
                          page.subtitle,
                          style: TextStyle(
                            fontSize: screenWidth < 400 ? 16 : 18,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w300,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const Spacer(),

                        // Page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length,
                            (dotIndex) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == dotIndex ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == dotIndex
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Next/Get Started button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: page.backgroundColor,
                              elevation: 8,
                              shadowColor: Colors.black.withValues(alpha: 0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              index == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: TextStyle(
                                fontSize: screenWidth < 400 ? 16 : 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
  });
}
