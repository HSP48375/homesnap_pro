import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class OnboardingProgressWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingProgressWidget({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      opacity: 0.06,
      isLight: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalPages,
          (index) => _buildProgressDot(index == currentPage),
        ),
      ),
    );
  }

  Widget _buildProgressDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      width: isActive ? 8.w : 3.w,
      height: 1.5.w,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.yellow : AppTheme.white.withAlpha(102),
        borderRadius: BorderRadius.circular(2.w),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppTheme.yellow.withAlpha(102),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
