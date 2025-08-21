import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.width,
    this.height,
    this.gradient,
    this.borderRadius,
    this.textStyle,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height ?? 48,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: widget.gradient ?? AppColors.primaryGradient,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: _isPressed ? 2 : 6,
              offset: Offset(0, _isPressed ? 1 : 3),
            ),
          ],
        ),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  widget.text,
                  style:
                      widget.textStyle ??
                      Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
        ),
      ),
    );
  }
}

class OutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? borderColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  State<OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<OutlineButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.borderColor ?? AppColors.primaryCoral;
    final textColor = widget.textColor ?? AppColors.primaryCoral;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height ?? 48,
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: _isPressed
              ? borderColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              : Text(
                  widget.text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
