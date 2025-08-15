import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../job_tracking_notifications.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback onTap;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      padding: EdgeInsets.all(4.w),
      opacity: notification.isRead
          ? 0.04
          : 0.08, // Different opacity for read/unread
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification icon
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getNotificationColor().withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getNotificationIcon(),
              color: _getNotificationColor(),
              size: 5.w,
            ),
          ),

          SizedBox(width: 3.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.black,
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Message
                Text(
                  notification.message,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),

                SizedBox(height: 1.h),

                // Timestamp
                Text(
                  _formatTimestamp(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary.withAlpha(179),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.jobComplete:
        return AppTheme.yellow;
      case NotificationType.statusUpdate:
        return AppTheme.black;
      case NotificationType.reminder:
        return AppTheme.textSecondary;
    }
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.jobComplete:
        return Icons.check_circle_outline;
      case NotificationType.statusUpdate:
        return Icons.update_outlined;
      case NotificationType.reminder:
        return Icons.schedule_outlined;
    }
  }

  String _formatTimestamp() {
    final now = DateTime.now();
    final difference = now.difference(notification.timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
