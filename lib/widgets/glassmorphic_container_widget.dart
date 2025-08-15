import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double opacity;
  final bool isLight;
  final VoidCallback? onTap;

  const GlassmorphicContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.opacity = 0.05,
    this.isLight = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(16.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding ?? const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: isLight
                    ? AppTheme.white.withOpacity(opacity)
                    : AppTheme.black.withOpacity(opacity),
                borderRadius: borderRadius ?? BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: isLight
                        ? AppTheme.black.withAlpha(15)
                        : AppTheme.white.withAlpha(15),
                    blurRadius: 20.0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: isLight
                        ? AppTheme.black.withAlpha(10)
                        : AppTheme.white.withAlpha(10),
                    blurRadius: 40.0,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
