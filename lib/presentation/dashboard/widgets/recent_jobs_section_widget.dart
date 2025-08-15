import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './recent_job_card_widget.dart';

class RecentJobsSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentJobs;
  final Function(Map<String, dynamic>) onJobTap;
  final Function(Map<String, dynamic>) onJobLongPress;

  const RecentJobsSectionWidget({
    super.key,
    required this.recentJobs,
    required this.onJobTap,
    required this.onJobLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Jobs',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to jobs screen
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentStart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        recentJobs.isEmpty
            ? _buildEmptyState()
            : SizedBox(
                height: 35.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 4.w),
                  itemCount: recentJobs.length,
                  itemBuilder: (context, index) {
                    final job = recentJobs[index];
                    return RecentJobCardWidget(
                      job: job,
                      onTap: () => onJobTap(job),
                      onLongPress: () => onJobLongPress(job),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 35.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderSubtle,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'photo_library',
            color: AppTheme.textSecondary,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Recent Jobs',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start your first property photography job\nto see your work history here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
