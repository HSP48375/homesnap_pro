import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../job_tracking_notifications.dart';

class JobCardWidget extends StatelessWidget {
  final JobData job;
  final VoidCallback onTap;

  const JobCardWidget({
    Key? key,
    required this.job,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      padding: EdgeInsets.all(5.w),
      opacity: 0.06, // Enhanced transparency for better background visibility
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Job ID
              Text(
                job.id,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.black,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Status badge
              _buildStatusBadge(),
            ],
          ),

          SizedBox(height: 2.h),

          // Property address
          Text(
            job.propertyAddress,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 1.h),

          // Service type
          Text(
            job.serviceType,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 3.h),

          // Progress bar
          _buildProgressBar(),

          SizedBox(height: 2.h),

          // Footer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Photo count
              Row(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    color: AppTheme.textSecondary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '${job.photoCount} photos',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Estimated completion
              if (job.status != JobStatus.ready)
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: AppTheme.textSecondary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatEstimatedTime(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    Color textColor;
    String statusText;

    switch (job.status) {
      case JobStatus.processing:
        badgeColor = AppTheme.yellow.withAlpha(51);
        textColor = AppTheme.black;
        statusText = 'Processing';
        break;
      case JobStatus.editing:
        badgeColor = AppTheme.yellow.withAlpha(102);
        textColor = AppTheme.black;
        statusText = 'Editing';
        break;
      case JobStatus.qualityCheck:
        badgeColor = AppTheme.yellow.withAlpha(153);
        textColor = AppTheme.black;
        statusText = 'Quality Check';
        break;
      case JobStatus.ready:
        badgeColor = AppTheme.yellow;
        textColor = AppTheme.black;
        statusText = 'Ready';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        statusText,
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(job.progress * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 1.w,
          decoration: BoxDecoration(
            color: AppTheme.borderSubtle,
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: job.progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.yellow,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatEstimatedTime() {
    final now = DateTime.now();
    final difference = job.estimatedCompletion.difference(now);

    if (difference.inHours > 0) {
      return '${difference.inHours}h remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m remaining';
    } else {
      return 'Due now';
    }
  }
}
