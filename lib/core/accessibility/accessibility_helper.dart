import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccessibilityHelper {
  // Screen reader support
  static Widget withSemantics({
    required Widget child,
    String? label,
    String? hint,
    bool? isButton,
    bool? isHeader,
    bool? isImage,
    bool? isTextField,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton ?? false,
      header: isHeader ?? false,
      image: isImage ?? false,
      textField: isTextField ?? false,
      onTap: onTap,
      child: child,
    );
  }

  // Focus management
  static void requestFocus(BuildContext context, FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void nextFocus(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  static void previousFocus(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  // Haptic feedback
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionChanged() {
    HapticFeedback.lightImpact();
  }

  static void vibrate() {
    HapticFeedback.vibrate();
  }

  // Accessibility text scaling
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  static bool isLargeText(BuildContext context) {
    return getTextScaleFactor(context) > 1.3;
  }

  // High contrast mode detection
  static bool isHighContrast(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  // Reduced motion detection
  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  // Screen size accessibility
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  // Color contrast helpers
  static double calculateContrastRatio(Color foreground, Color background) {
    final luminance1 = foreground.computeLuminance();
    final luminance2 = background.computeLuminance();
    
    final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
    final darkest = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (brightest + 0.05) / (darkest + 0.05);
  }

  static bool hasGoodContrast(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 4.5;
  }

  // Accessibility-friendly colors
  static Color getAccessibleTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // Focus indicators
  static Widget withFocusIndicator({
    required Widget child,
    Color? focusColor,
    double? focusWidth,
    BorderRadius? borderRadius,
  }) {
    return Focus(
      onFocusChange: (hasFocus) {
        // Optional: Add haptic feedback on focus
        if (hasFocus) {
          lightImpact();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          border: Border.all(
            color: focusColor ?? Colors.transparent,
            width: focusWidth ?? 2,
          ),
        ),
        child: child,
      ),
    );
  }

  // Loading states with accessibility
  static Widget accessibleLoading({
    required String loadingText,
    Widget? indicator,
  }) {
    return Semantics(
      label: loadingText,
      value: 'Loading',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          indicator ?? const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(loadingText),
        ],
      ),
    );
  }

  // Error states with accessibility
  static Widget accessibleError({
    required String errorMessage,
    String? retryLabel,
    VoidCallback? onRetry,
  }) {
    return Semantics(
      label: errorMessage,
      value: 'Error',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryLabel ?? 'Retry'),
            ),
          ],
        ],
      ),
    );
  }

  // Empty states with accessibility
  static Widget accessibleEmpty({
    required String emptyMessage,
    String? actionLabel,
    VoidCallback? onAction,
    IconData? icon,
  }) {
    return Semantics(
      label: emptyMessage,
      value: 'Empty state',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          if (onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel ?? 'Action'),
            ),
          ],
        ],
      ),
    );
  }

  // Keyboard navigation helpers
  static Widget withKeyboardNavigation({
    required Widget child,
    FocusNode? focusNode,
    VoidCallback? onEnter,
    VoidCallback? onSpace,
    VoidCallback? onEscape,
  }) {
    return KeyboardListener(
      focusNode: focusNode ?? FocusNode(),
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.enter:
              onEnter?.call();
              break;
            case LogicalKeyboardKey.space:
              onSpace?.call();
              break;
            case LogicalKeyboardKey.escape:
              onEscape?.call();
              break;
          }
        }
      },
      child: child,
    );
  }

  // Screen reader announcements
  static void announceToScreenReader(BuildContext context, String message) {
    // Note: SemanticsService is not available in Flutter, using alternative approach
    // In a real app, you would use a platform-specific solution
  }

  // Accessibility-friendly image
  static Widget accessibleImage({
    required String imageUrl,
    required String altText,
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Semantics(
      label: altText,
      image: true,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Semantics(
            label: 'Image failed to load: $altText',
            child: Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          );
        },
      ),
    );
  }

  // Accessibility-friendly button
  static Widget accessibleButton({
    required String label,
    String? hint,
    required VoidCallback onPressed,
    Widget? child,
    bool isEnabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: isEnabled,
      onTap: isEnabled ? onPressed : null,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        child: child ?? Text(label),
      ),
    );
  }

  // Accessibility-friendly text field
  static Widget accessibleTextField({
    required String label,
    String? hint,
    String? errorText,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      textField: true,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          errorText: errorText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
