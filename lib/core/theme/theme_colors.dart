import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Theme-aware colors that automatically adapt to light/dark themes
class ThemeColors {
  static Color getBackground(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  static Color getOnSurface(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getOnBackground(BuildContext context) {
    return Theme.of(context).colorScheme.onBackground;
  }

  static Color getPrimary(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getSecondary(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  static Color getError(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }

  static Color getSuccess(BuildContext context) {
    return AppColors.success;
  }

  static Color getWarning(BuildContext context) {
    return AppColors.warning;
  }

  static Color getInfo(BuildContext context) {
    return AppColors.info;
  }

  // Gray colors that adapt to theme
  static Color getGray50(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray50
        : AppColors.gray900;
  }

  static Color getGray100(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray100
        : AppColors.gray800;
  }

  static Color getGray200(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray200
        : AppColors.gray700;
  }

  static Color getGray300(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray300
        : AppColors.gray600;
  }

  static Color getGray400(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray400
        : AppColors.gray500;
  }

  static Color getGray500(BuildContext context) {
    return AppColors.gray500; // Same in both themes
  }

  static Color getGray600(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray600
        : AppColors.gray400;
  }

  static Color getGray700(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray700
        : AppColors.gray300;
  }

  static Color getGray800(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray800
        : AppColors.gray200;
  }

  static Color getGray900(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray900
        : AppColors.gray100;
  }

  // Shadow colors that adapt to theme
  static Color getShadow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.shadowLight
        : AppColors.shadowDark;
  }

  // Text colors that adapt to theme
  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
  }

  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
  }

  // Border colors that adapt to theme
  static Color getBorder(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray200
        : AppColors.gray700;
  }

  // Divider colors that adapt to theme
  static Color getDivider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray200
        : AppColors.gray700;
  }

  // Input field colors that adapt to theme
  static Color getInputBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.gray100
        : AppColors.gray800;
  }

  // Card colors that adapt to theme
  static Color getCardBackground(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  // AppBar colors that adapt to theme
  static Color getAppBarBackground(BuildContext context) {
    return Theme.of(context).appBarTheme.backgroundColor ?? 
           Theme.of(context).colorScheme.surface;
  }

  static Color getAppBarForeground(BuildContext context) {
    return Theme.of(context).appBarTheme.foregroundColor ?? 
           Theme.of(context).colorScheme.onSurface;
  }

  // Bottom navigation colors that adapt to theme
  static Color getBottomNavBackground(BuildContext context) {
    return Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? 
           Theme.of(context).colorScheme.surface;
  }

  // Status colors that work in both themes
  static Color getStatusSuccess(BuildContext context) {
    return AppColors.success;
  }

  static Color getStatusWarning(BuildContext context) {
    return AppColors.warning;
  }

  static Color getStatusError(BuildContext context) {
    return AppColors.error;
  }

  static Color getStatusInfo(BuildContext context) {
    return AppColors.info;
  }

  // SnackBar colors that adapt to theme
  static Color getSnackBarSuccess(BuildContext context) {
    return AppColors.success;
  }

  static Color getSnackBarError(BuildContext context) {
    return AppColors.error;
  }

  static Color getSnackBarWarning(BuildContext context) {
    return AppColors.warning;
  }

  static Color getSnackBarInfo(BuildContext context) {
    return AppColors.info;
  }
}
