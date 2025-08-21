import 'package:flutter/material.dart';
import '../branding/brand_constants.dart';
import '../accessibility/accessibility_helper.dart';

enum LogoSize {
  small,
  medium,
  large,
  xLarge,
  xxLarge,
  custom,
}

enum LogoTheme {
  primary,
  white,
  dark,
  adaptive,
}

class BrandLogo extends StatelessWidget {
  final LogoSize size;
  final LogoTheme theme;
  final double? customSize;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool showTagline;
  final bool animate;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const BrandLogo({
    super.key,
    this.size = LogoSize.medium,
    this.theme = LogoTheme.primary,
    this.customSize,
    this.onTap,
    this.semanticLabel,
    this.showTagline = false,
    this.animate = false,
    this.animationDuration,
    this.animationCurve,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = _getLogoAsset(isDarkMode);
    final logoSize = _getLogoSize();
    final logoColor = _getLogoColor(isDarkMode);

    Widget logoWidget = Image.asset(
      logoAsset,
      width: logoSize,
      height: logoSize,
      color: logoColor,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackLogo(logoSize, logoColor);
      },
    );

    // Add animation if enabled
    if (animate) {
      logoWidget = TweenAnimationBuilder<double>(
        duration: animationDuration ?? BrandConstants.brandAnimationMedium,
        curve: animationCurve ?? BrandConstants.brandCurveEase,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          );
        },
        child: logoWidget,
      );
    }

    // Add tap functionality
    if (onTap != null) {
      logoWidget = GestureDetector(
        onTap: () {
          AccessibilityHelper.lightImpact();
          onTap!();
        },
        child: logoWidget,
      );
    }

    // Add accessibility
    logoWidget = AccessibilityHelper.withSemantics(
      child: logoWidget,
      label: semanticLabel ?? 'MAAWA Logo',
      isImage: true,
      onTap: onTap,
    );

    // Add tagline if requested
    if (showTagline) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          const SizedBox(height: BrandConstants.brandSpacingSmall),
          Text(
            BrandConstants.appTagline,
            style: TextStyle(
              fontSize: _getTaglineFontSize(),
              color: _getTaglineColor(isDarkMode),
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return logoWidget;
  }

  String _getLogoAsset(bool isDarkMode) {
    switch (theme) {
      case LogoTheme.primary:
        return BrandConstants.logoPrimary;
      case LogoTheme.white:
        return BrandConstants.logoWhite;
      case LogoTheme.dark:
        return BrandConstants.logoDark;
      case LogoTheme.adaptive:
        return isDarkMode ? BrandConstants.logoWhite : BrandConstants.logoDark;
    }
  }

  double _getLogoSize() {
    if (customSize != null) return customSize!;
    
    switch (size) {
      case LogoSize.small:
        return BrandConstants.logoSizeSmall;
      case LogoSize.medium:
        return BrandConstants.logoSizeMedium;
      case LogoSize.large:
        return BrandConstants.logoSizeLarge;
      case LogoSize.xLarge:
        return BrandConstants.logoSizeXLarge;
      case LogoSize.xxLarge:
        return BrandConstants.logoSizeXXLarge;
      case LogoSize.custom:
        return customSize ?? BrandConstants.logoSizeMedium;
    }
  }

  Color? _getLogoColor(bool isDarkMode) {
    switch (theme) {
      case LogoTheme.primary:
        return null; // Use original colors
      case LogoTheme.white:
        return Colors.white;
      case LogoTheme.dark:
        return Colors.black;
      case LogoTheme.adaptive:
        return isDarkMode ? Colors.white : Colors.black;
    }
  }

  Color _getTaglineColor(bool isDarkMode) {
    if (isDarkMode) {
      return Colors.white.withValues(alpha: 0.7);
    } else {
      return Colors.black.withValues(alpha: 0.7);
    }
  }

  double _getTaglineFontSize() {
    switch (size) {
      case LogoSize.small:
        return 10.0;
      case LogoSize.medium:
        return 12.0;
      case LogoSize.large:
        return 14.0;
      case LogoSize.xLarge:
        return 16.0;
      case LogoSize.xxLarge:
        return 18.0;
      case LogoSize.custom:
        return 12.0;
    }
  }

  Widget _buildFallbackLogo(double size, Color? color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? BrandConstants.primaryCoral,
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Center(
        child: Text(
          'M',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Specialized logo widgets for common use cases
class BrandLogoSmall extends StatelessWidget {
  final LogoTheme theme;
  final VoidCallback? onTap;

  const BrandLogoSmall({
    super.key,
    this.theme = LogoTheme.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BrandLogo(
      size: LogoSize.small,
      theme: theme,
      onTap: onTap,
    );
  }
}

class BrandLogoMedium extends StatelessWidget {
  final LogoTheme theme;
  final VoidCallback? onTap;
  final bool showTagline;

  const BrandLogoMedium({
    super.key,
    this.theme = LogoTheme.primary,
    this.onTap,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return BrandLogo(
      size: LogoSize.medium,
      theme: theme,
      onTap: onTap,
      showTagline: showTagline,
    );
  }
}

class BrandLogoLarge extends StatelessWidget {
  final LogoTheme theme;
  final VoidCallback? onTap;
  final bool showTagline;
  final bool animate;

  const BrandLogoLarge({
    super.key,
    this.theme = LogoTheme.primary,
    this.onTap,
    this.showTagline = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return BrandLogo(
      size: LogoSize.large,
      theme: theme,
      onTap: onTap,
      showTagline: showTagline,
      animate: animate,
    );
  }
}

class BrandLogoXLarge extends StatelessWidget {
  final LogoTheme theme;
  final VoidCallback? onTap;
  final bool showTagline;
  final bool animate;

  const BrandLogoXLarge({
    super.key,
    this.theme = LogoTheme.primary,
    this.onTap,
    this.showTagline = true,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return BrandLogo(
      size: LogoSize.xLarge,
      theme: theme,
      onTap: onTap,
      showTagline: showTagline,
      animate: animate,
    );
  }
}

// Logo with app name
class BrandLogoWithName extends StatelessWidget {
  final LogoSize logoSize;
  final LogoTheme theme;
  final bool showTagline;
  final bool animate;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const BrandLogoWithName({
    super.key,
    this.logoSize = LogoSize.medium,
    this.theme = LogoTheme.primary,
    this.showTagline = false,
    this.animate = false,
    this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = _getTextColor(isDarkMode);

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BrandLogo(
            size: logoSize,
            theme: theme,
            animate: animate,
          ),
          const SizedBox(width: BrandConstants.brandSpacingSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                BrandConstants.appName,
                style: TextStyle(
                  fontSize: _getAppNameFontSize(),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (showTagline) ...[
                const SizedBox(height: 2),
                Text(
                  BrandConstants.appTagline,
                  style: TextStyle(
                    fontSize: _getTaglineFontSize(),
                    color: textColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getTextColor(bool isDarkMode) {
    switch (theme) {
      case LogoTheme.primary:
        return isDarkMode ? Colors.white : Colors.black;
      case LogoTheme.white:
        return Colors.white;
      case LogoTheme.dark:
        return Colors.black;
      case LogoTheme.adaptive:
        return isDarkMode ? Colors.white : Colors.black;
    }
  }

  double _getAppNameFontSize() {
    switch (logoSize) {
      case LogoSize.small:
        return 14.0;
      case LogoSize.medium:
        return 16.0;
      case LogoSize.large:
        return 20.0;
      case LogoSize.xLarge:
        return 24.0;
      case LogoSize.xxLarge:
        return 28.0;
      case LogoSize.custom:
        return 16.0;
    }
  }

  double _getTaglineFontSize() {
    switch (logoSize) {
      case LogoSize.small:
        return 10.0;
      case LogoSize.medium:
        return 12.0;
      case LogoSize.large:
        return 14.0;
      case LogoSize.xLarge:
        return 16.0;
      case LogoSize.xxLarge:
        return 18.0;
      case LogoSize.custom:
        return 12.0;
    }
  }
}
