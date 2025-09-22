import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_colors.dart';

class ThemeToggle extends StatefulWidget {
  final double size;
  final bool showLabel;
  final EdgeInsetsGeometry? padding;

  const ThemeToggle({
    super.key,
    this.size = 48,
    this.showLabel = false,
    this.padding,
  });

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final currentMode = themeProvider.themeMode;

    // Animate the toggle
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Determine next theme mode
    AppThemeMode nextMode;
    switch (currentMode) {
      case AppThemeMode.light:
        nextMode = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        nextMode = AppThemeMode.system;
        break;
      case AppThemeMode.system:
        nextMode = AppThemeMode.light;
        break;
    }

    themeProvider.setThemeMode(nextMode);
  }

  IconData _getCurrentIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_system_daydream;
      default:
        return Icons.settings_system_daydream;
    }
  }

  Color _getCurrentColor(AppThemeMode mode, bool isDark) {
    switch (mode) {
      case AppThemeMode.light:
        return AppColors.primaryOrange;
      case AppThemeMode.dark:
        return AppColors.primaryTurquoise;
      case AppThemeMode.system:
        return AppColors.primaryCoral;
      default:
        return AppColors.primaryCoral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final currentMode = themeProvider.themeMode;
        final icon = _getCurrentIcon(currentMode);
        final color = _getCurrentColor(currentMode, isDark);

        return Container(
          padding: widget.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showLabel) ...[
                Text(
                  themeProvider.themeModeName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.gray400 : AppColors.gray600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              GestureDetector(
                onTap: _toggleTheme,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [color, color.withValues(alpha: 0.8)],
                            ),
                            borderRadius: BorderRadius.circular(
                              widget.size / 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: widget.size * 0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThemeToggleButton extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? padding;
  final bool showBackground;

  const ThemeToggleButton({
    super.key,
    this.size = 40,
    this.padding,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final currentMode = themeProvider.themeMode;
        final icon = _getCurrentIcon(currentMode);
        final color = _getCurrentColor(currentMode, isDark);

        return Container(
          padding: padding,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final nextMode = _getNextMode(currentMode);
                themeProvider.setThemeMode(nextMode);
              },
              borderRadius: BorderRadius.circular(size / 2),
              child: Container(
                width: size,
                height: size,
                decoration: showBackground
                    ? BoxDecoration(
                        color: isDark ? AppColors.gray800 : AppColors.gray100,
                        borderRadius: BorderRadius.circular(size / 2),
                        border: Border.all(
                          color: isDark ? AppColors.gray700 : AppColors.gray200,
                          width: 1,
                        ),
                      )
                    : null,
                child: Icon(
                  icon,
                  color: showBackground
                      ? (isDark ? AppColors.gray300 : AppColors.gray700)
                      : color,
                  size: size * 0.6,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCurrentIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_system_daydream;
      default:
        return Icons.settings_system_daydream;
    }
  }

  Color _getCurrentColor(AppThemeMode mode, bool isDark) {
    switch (mode) {
      case AppThemeMode.light:
        return AppColors.primaryOrange;
      case AppThemeMode.dark:
        return AppColors.primaryTurquoise;
      case AppThemeMode.system:
        return AppColors.primaryCoral;
      default:
        return AppColors.primaryCoral;
    }
  }

  AppThemeMode _getNextMode(AppThemeMode currentMode) {
    switch (currentMode) {
      case AppThemeMode.light:
        return AppThemeMode.dark;
      case AppThemeMode.dark:
        return AppThemeMode.system;
      case AppThemeMode.system:
        return AppThemeMode.light;
    }
  }
}
