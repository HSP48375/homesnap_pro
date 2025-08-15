import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../onboarding_flow.dart';

class OnboardingStepWidget extends StatelessWidget {
  final OnboardingData data;

  const OnboardingStepWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      padding: EdgeInsets.all(6.w),
      opacity: 0.08, // Enhanced transparency for better background visibility
      isLight: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            data.title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),

          SizedBox(height: 3.h),

          // Description
          Text(
            data.description,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.white.withAlpha(230),
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),

          SizedBox(height: 4.h),

          // Features list
          Column(
            children: data.features
                .map((feature) => _buildFeatureItem(feature))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Yellow check icon
          Container(
            margin: EdgeInsets.only(top: 0.5.h, right: 3.w),
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: AppTheme.yellow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: AppTheme.black,
              size: 3.w,
            ),
          ),

          // Feature text
          Expanded(
            child: Text(
              feature,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.white.withAlpha(217),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
