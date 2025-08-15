import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glassmorphic_container_widget.dart';
import './widgets/filter_bar_widget.dart';
import './widgets/job_card_widget.dart';
import './widgets/notification_card_widget.dart';

class JobTrackingNotifications extends StatefulWidget {
  const JobTrackingNotifications({Key? key}) : super(key: key);

  @override
  State<JobTrackingNotifications> createState() =>
      _JobTrackingNotificationsState();
}

class _JobTrackingNotificationsState extends State<JobTrackingNotifications>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String _selectedFilter = 'All';
  bool _isLoading = false;

  // Mock job data
  final List<JobData> _jobs = [
    JobData(
      id: 'HSP-2025-001',
      propertyAddress: '123 Maple Street, Downtown',
      status: JobStatus.processing,
      progress: 0.25,
      estimatedCompletion: DateTime.now().add(const Duration(hours: 18)),
      serviceType: 'Standard Photography',
      photoCount: 25,
    ),
    JobData(
      id: 'HSP-2025-002',
      propertyAddress: '456 Oak Avenue, Midtown',
      status: JobStatus.editing,
      progress: 0.65,
      estimatedCompletion: DateTime.now().add(const Duration(hours: 8)),
      serviceType: 'Premium + Virtual Staging',
      photoCount: 35,
    ),
    JobData(
      id: 'HSP-2025-003',
      propertyAddress: '789 Pine Road, Uptown',
      status: JobStatus.ready,
      progress: 1.0,
      estimatedCompletion: DateTime.now(),
      serviceType: 'Drone + HDR Package',
      photoCount: 42,
    ),
  ];

  // Mock notifications
  final List<NotificationData> _notifications = [
    NotificationData(
      id: '1',
      title: 'Job HSP-2025-003 Complete',
      message: 'Your photos for 789 Pine Road are ready for download',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.jobComplete,
      isRead: false,
    ),
    NotificationData(
      id: '2',
      title: 'Quality Check Started',
      message: 'HSP-2025-002 photos are now in quality review',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.statusUpdate,
      isRead: true,
    ),
    NotificationData(
      id: '3',
      title: 'Processing Started',
      message: 'HSP-2025-001 photos are being processed',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      type: NotificationType.statusUpdate,
      isRead: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  List<JobData> _getFilteredJobs() {
    if (_selectedFilter == 'All') return _jobs;

    return _jobs.where((job) {
      switch (_selectedFilter) {
        case 'Active':
          return job.status != JobStatus.ready;
        case 'Complete':
          return job.status == JobStatus.ready;
        case 'Processing':
          return job.status == JobStatus.processing;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Job Tracking',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: AppTheme.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_outline),
                  SizedBox(width: 2.w),
                  Text('Jobs'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_outlined),
                  SizedBox(width: 2.w),
                  Text('Notifications'),
                  if (_notifications.where((n) => !n.isRead).isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: 1.w),
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          BoxConstraints(minWidth: 4.w, minHeight: 4.w),
                      child: Center(
                        child: Text(
                          '${_notifications.where((n) => !n.isRead).length}',
                          style: TextStyle(
                            color: AppTheme.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Emergency contact button
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: GlassmorphicContainer(
              padding: EdgeInsets.all(2.w),
              opacity: 0.05,
              child: IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  _showEmergencyContact();
                },
                icon: Icon(
                  Icons.support_agent,
                  color: AppTheme.black,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobsTab(),
          _buildNotificationsTab(),
        ],
      ),
    );
  }

  Widget _buildJobsTab() {
    final filteredJobs = _getFilteredJobs();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      color: AppTheme.yellow,
      backgroundColor: AppTheme.white,
      child: Column(
        children: [
          // Filter bar
          FilterBarWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
              HapticFeedback.selectionClick();
            },
          ),

          // Jobs list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(4.w),
              itemCount: filteredJobs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.w),
                  child: JobCardWidget(
                    job: filteredJobs[index],
                    onTap: () => _showJobDetails(filteredJobs[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.yellow,
      backgroundColor: AppTheme.white,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 3.w),
            child: NotificationCardWidget(
              notification: _notifications[index],
              onTap: () => _handleNotificationTap(_notifications[index]),
            ),
          );
        },
      ),
    );
  }

  void _showJobDetails(JobData job) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.w),
            topRight: Radius.circular(8.w),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 12.w,
                  height: 1.w,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              Text(
                'Job Details',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.black,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 3.h),

              // Job details content would go here
              Text(
                'Job ID: ${job.id}',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),

              SizedBox(height: 2.h),

              Text(
                'Property: ${job.propertyAddress}',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),

              SizedBox(height: 2.h),

              Text(
                'Service: ${job.serviceType}',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationData notification) {
    HapticFeedback.lightImpact();

    // Mark as read
    setState(() {
      notification.isRead = true;
    });
  }

  void _showEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Support'),
        content:
            Text('Contact our support team immediately for urgent issues.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle emergency contact
            },
            child: Text('Call Support'),
          ),
        ],
      ),
    );
  }
}

// Data models
enum JobStatus { processing, editing, qualityCheck, ready }

class JobData {
  final String id;
  final String propertyAddress;
  final JobStatus status;
  final double progress;
  final DateTime estimatedCompletion;
  final String serviceType;
  final int photoCount;

  JobData({
    required this.id,
    required this.propertyAddress,
    required this.status,
    required this.progress,
    required this.estimatedCompletion,
    required this.serviceType,
    required this.photoCount,
  });
}

enum NotificationType { jobComplete, statusUpdate, reminder }

class NotificationData {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}
