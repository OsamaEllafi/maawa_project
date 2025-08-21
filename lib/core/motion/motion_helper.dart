import 'package:flutter/material.dart';
import '../theme/app_tokens.dart';

class MotionHelper {
  // Fade animations
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.decelerated,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget fadeOut({
    required Widget child,
    Duration? duration,
    Curve? curve,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.accelerated,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Scale animations
  static Widget scaleIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? beginScale,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.emphasized,
      tween: Tween(begin: beginScale ?? 0.8, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget scaleOut({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? endScale,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.accelerated,
      tween: Tween(begin: 1.0, end: endScale ?? 0.8),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Slide animations
  static Widget slideInFromLeft({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? offset,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? AppMotion.pageBase,
      curve: curve ?? AppCurves.decelerated,
      tween: Tween(
        begin: Offset(-(offset ?? 1.0), 0.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value.dx * MediaQuery.of(context).size.width,
            value.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromRight({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? offset,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? AppMotion.pageBase,
      curve: curve ?? AppCurves.decelerated,
      tween: Tween(
        begin: Offset(offset ?? 1.0, 0.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value.dx * MediaQuery.of(context).size.width,
            value.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  static Widget slideInFromBottom({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? offset,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<Offset>(
      duration: duration ?? AppMotion.pageBase,
      curve: curve ?? AppCurves.decelerated,
      tween: Tween(
        begin: Offset(0.0, offset ?? 1.0),
        end: Offset.zero,
      ),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value.dx * MediaQuery.of(context).size.width,
            value.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: child,
    );
  }

  // Staggered animations
  static Widget staggeredList({
    required List<Widget> children,
    Duration? itemDuration,
    Duration? staggerDelay,
    Curve? curve,
    bool enabled = true,
  }) {
    if (!enabled) {
      return Column(children: children);
    }
    
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return TweenAnimationBuilder<double>(
          duration: (itemDuration ?? AppMotion.base) + 
                   (staggerDelay ?? AppMotion.fast) * index,
          curve: curve ?? AppCurves.decelerated,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: child,
        );
      }).toList(),
    );
  }

  // Pulse animation
  static Widget pulse({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? minScale,
    double? maxScale,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.extended,
      curve: curve ?? Curves.easeInOut,
      tween: Tween(
        begin: minScale ?? 1.0,
        end: maxScale ?? 1.1,
      ),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Shake animation
  static Widget shake({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? intensity,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.base,
      curve: curve ?? Curves.easeInOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        final shake = (intensity ?? 10.0) * 
                     (1 - value) * 
                     (value * 2 - 1) * 
                     (value * 2 - 1);
        
        return Transform.translate(
          offset: Offset(shake, 0),
          child: child,
        );
      },
      child: child,
    );
  }

  // Bounce animation
  static Widget bounce({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? intensity,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.extended,
      curve: curve ?? Curves.bounceOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 1.0 + (intensity ?? 0.2) * value,
          child: child,
        );
      },
      child: child,
    );
  }

  // Loading shimmer animation
  static Widget shimmer({
    required Widget child,
    Duration? duration,
    Color? shimmerColor,
    bool enabled = true,
  }) {
    if (!enabled) return child;
    
    return TweenAnimationBuilder<double>(
      duration: duration ?? AppMotion.extended,
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                shimmerColor ?? Colors.white.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              stops: [
                (value - 0.3).clamp(0.0, 1.0),
                value,
                (value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  // Page transition animations
  static Widget pageTransition({
    required Widget child,
    required Animation<double> animation,
    bool slideFromRight = true,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(slideFromRight ? 1.0 : -1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: AppCurves.decelerated,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  // Hero-like shared element transition
  static Widget sharedElementTransition({
    required Widget child,
    required String tag,
    Duration? duration,
    Curve? curve,
  }) {
    return Hero(
      tag: tag,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          },
          child: child,
        );
      },
      child: child,
    );
  }

  // Animated container with motion
  static Widget animatedContainer({
    required Widget child,
    Duration? duration,
    Curve? curve,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxDecoration? decoration,
    double? width,
    double? height,
  }) {
    return AnimatedContainer(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.decelerated,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }

  // Animated opacity
  static Widget animatedOpacity({
    required Widget child,
    required bool visible,
    Duration? duration,
    Curve? curve,
  }) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.decelerated,
      child: child,
    );
  }

  // Animated size
  static Widget animatedSize({
    required Widget child,
    Duration? duration,
    Curve? curve,
    AlignmentGeometry? alignment,
  }) {
    return AnimatedSize(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.decelerated,
      alignment: alignment ?? Alignment.topCenter,
      child: child,
    );
  }

  // Animated position
  static Widget animatedPositioned({
    required Widget child,
    Duration? duration,
    Curve? curve,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    return AnimatedPositioned(
      duration: duration ?? AppMotion.base,
      curve: curve ?? AppCurves.decelerated,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}
