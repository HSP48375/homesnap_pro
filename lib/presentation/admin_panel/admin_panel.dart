import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/blurred_background_widget.dart';
import '../../widgets/glassmorphic_container_widget.dart';
import './widgets/admin_stats_widget.dart';
import './widgets/job_queue_widget.dart';
import './widgets/pricing_management_widget.dart';
import './widgets/user_management_widget.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  final Map<String, dynamic> _adminStats = {
    'total_users': 1247,
    'active_jobs': 89,
    'completed_today': 156,
    'revenue_today': 4892.50,
    'pending_payments': 12,
    'failed_payments': 3,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredBackgroundWidget(
        blurIntensity: 12.0,
        overlayColor: AppTheme.black.withAlpha(102),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              GlassmorphicContainer(
                opacity: 0.1,
                borderRadius: BorderRadius.circular(0),
                padding: EdgeInsets.all(4.w),
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.white,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin Panel',
                            style: GoogleFonts.poppins(
                              color: AppTheme.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'HomeSnap Pro Management',
                            style: GoogleFonts.poppins(
                              color: AppTheme.yellow,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: AppTheme.black,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.white.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.white.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppTheme.black,
                  unselectedLabelColor: AppTheme.white.withAlpha(179),
                  dividerColor: Colors.transparent,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  indicatorPadding: EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Jobs'),
                    Tab(text: 'Users'),
                    Tab(text: 'Pricing'),
                  ],
                ),
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildJobsTab(),
                    _buildUsersTab(),
                    _buildPricingTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminStatsWidget(stats: _adminStats),

          SizedBox(height: 3.h),

          // Quick Actions
          GlassmorphicContainer(
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Actions',
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        'Process Queue',
                        Icons.play_arrow,
                        AppTheme.yellow,
                        () => _showSnackbar('Processing queue...'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildQuickActionCard(
                        'Send Notifications',
                        Icons.notifications,
                        AppTheme.yellow,
                        () => _showSnackbar('Notifications sent!'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        'Export Data',
                        Icons.download,
                        AppTheme.white,
                        () => _showSnackbar('Exporting data...'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildQuickActionCard(
                        'System Health',
                        Icons.health_and_safety,
                        AppTheme.white,
                        () => _showSnackbar('System: Healthy'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Recent Activity
          GlassmorphicContainer(
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildActivityItem(
                  'New user registration: john.doe@email.com',
                  '2 minutes ago',
                  Icons.person_add,
                ),
                _buildActivityItem(
                  'Payment processed: \$89.00 - Job #1247',
                  '5 minutes ago',
                  Icons.payment,
                ),
                _buildActivityItem(
                  'Job completed: Virtual staging - Ocean Drive',
                  '12 minutes ago',
                  Icons.check_circle,
                ),
                _buildActivityItem(
                  'Failed payment retry: \$149.99',
                  '18 minutes ago',
                  Icons.error,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsTab() {
    return JobQueueWidget();
  }

  Widget _buildUsersTab() {
    return UserManagementWidget();
  }

  Widget _buildPricingTab() {
    return PricingManagementWidget();
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.white.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.white.withAlpha(51),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: AppTheme.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.white.withAlpha(13),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.yellow,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: AppTheme.white.withAlpha(128),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.yellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
