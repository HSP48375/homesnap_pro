import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../services/job_service.dart';
import '../../widgets/blurred_background_widget.dart';
import '../../widgets/chatbot_widget.dart';
import '../../widgets/glassmorphic_container_widget.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/quick_actions_grid_widget.dart';
import './widgets/recent_jobs_section_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;
  bool _isLoading = true;

  // Services
  final AuthService _authService = AuthService();
  final JobService _jobService = JobService();

  // Data
  List<Map<String, dynamic>> _recentJobs = [];
  Map<String, dynamic>? _userProfile;
  Map<String, dynamic> _jobStats = {};

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await _authService.initialize();
      await _jobService.initialize();
      await _loadDashboardData();
    } catch (e) {
      debugPrint('Failed to initialize services: $e');
      _loadMockData();
    }
  }

  Future<void> _loadDashboardData() async {
    if (!_authService.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/login-screen');
      return;
    }

    try {
      final results = await Future.wait([
        _authService.getUserProfile(),
        _jobService.getRecentJobs(),
        _jobService.getUserJobStats(),
      ]);

      setState(() {
        _userProfile = results[0] as Map<String, dynamic>?;
        _recentJobs = List<Map<String, dynamic>>.from(results[1] as List);
        _jobStats = results[2] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      _loadMockData();
    }
  }

  void _loadMockData() {
    setState(() {
      _recentJobs = [
        {
          "id": 1,
          "properties": {"address": "123 Sunset Boulevard, Beverly Hills, CA"},
          "status": "completed",
          "total_photos": 24,
          "created_at": "2025-07-20T00:00:00Z",
          "total_amount": "149.99",
          "photos": [
            {
              "thumbnail_url":
                  "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
            }
          ]
        },
        {
          "id": 2,
          "properties": {"address": "456 Ocean Drive, Miami Beach, FL"},
          "status": "processing",
          "total_photos": 18,
          "created_at": "2025-07-21T00:00:00Z",
          "total_amount": "199.99",
          "photos": [
            {
              "thumbnail_url":
                  "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3"
            }
          ]
        },
      ];
      _userProfile = {"full_name": "Sarah Johnson", "role": "agent"};
      _jobStats = {
        "total_jobs": 15,
        "completed_jobs": 12,
        "processing_jobs": 3,
        "total_spent": 2449.85
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: BlurredBackgroundWidget(
          blurIntensity: 12.0,
          overlayColor: AppTheme.black.withAlpha(102),
          child: Center(
            child: GlassmorphicContainer(
              opacity: 0.1,
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.yellow,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Loading Dashboard...',
                    style: GoogleFonts.poppins(
                      color: AppTheme.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          BlurredBackgroundWidget(
            blurIntensity: 10.0,
            overlayColor: AppTheme.black.withAlpha(77),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: AppTheme.yellow,
                backgroundColor: AppTheme.white.withAlpha(230),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2.h),

                            // Greeting Header with glassmorphic design
                            GlassmorphicContainer(
                              opacity: 0.1,
                              borderRadius: BorderRadius.circular(20),
                              padding: EdgeInsets.all(5.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome back,',
                                          style: GoogleFonts.poppins(
                                            color:
                                                AppTheme.white.withAlpha(204),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          _userProfile?['full_name'] ?? "User",
                                          style: GoogleFonts.poppins(
                                            color: AppTheme.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _handleNotificationTap,
                                    child: Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.yellow,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.notifications,
                                        color: AppTheme.black,
                                        size: 6.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 4.h),

                            // Start New Job Card with Order Floorplan option
                            GlassmorphicContainer(
                              opacity: 0.15,
                              borderRadius: BorderRadius.circular(24),
                              padding: EdgeInsets.all(6.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ready for your next project?',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Capture photos with professional quality or order a floorplan',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.white.withAlpha(204),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),

                                  // Two action buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: AppTheme.yellow,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppTheme.yellow
                                                    .withAlpha(102),
                                                blurRadius: 12,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _handleStartNewJob,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.camera_alt,
                                                  color: AppTheme.black,
                                                  size: 5.w,
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  'Start New Job',
                                                  style: GoogleFonts.poppins(
                                                    color: AppTheme.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.w),
                                      Expanded(
                                        child: Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppTheme.yellow,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: _handleOrderFloorplan,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.architecture,
                                                  color: AppTheme.yellow,
                                                  size: 5.w,
                                                ),
                                                SizedBox(width: 2.w),
                                                Text(
                                                  'Order Floorplan',
                                                  style: GoogleFonts.poppins(
                                                    color: AppTheme.yellow,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 4.h),

                            // Recent Jobs Section
                            RecentJobsSectionWidget(
                              recentJobs: _recentJobs,
                              onJobTap: _handleJobTap,
                              onJobLongPress: _handleJobLongPress,
                            ),

                            SizedBox(height: 4.h),

                            // Quick Actions Grid
                            QuickActionsGridWidget(
                              onReorderTap: _handleReorderTap,
                              onTutorialTap: _handleTutorialTap,
                              onCalculatorTap: _handleCalculatorTap,
                              onSupportTap: _handleSupportTap,
                            ),

                            SizedBox(
                                height: 12.h), // Bottom padding for navigation
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Add chatbot widget
          const ChatbotWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: AppTheme.yellow,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppTheme.yellow.withAlpha(102),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _handleStartNewJob,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.add,
            color: AppTheme.black,
            size: 8.w,
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await _loadDashboardData();
    } catch (e) {
      debugPrint('Refresh error: $e');
    }

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Jobs refreshed successfully',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.yellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _handleNotificationTap() {
    Navigator.pushNamed(context, '/job-tracking-notifications');
  }

  void _handleStartNewJob() {
    Navigator.pushNamed(context, '/new-job-screen');
  }

  void _handleOrderFloorplan() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GlassmorphicContainer(
        opacity: 0.95,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.black.withAlpha(128),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              '2D Floorplan Service',
              style: GoogleFonts.poppins(
                color: AppTheme.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.yellow.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.yellow),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.architecture,
                          color: AppTheme.yellow, size: 6.w),
                      SizedBox(width: 3.w),
                      Text(
                        '\$25 per floorplan',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'White-label option: +\$5 (adds your logo & contact info)',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.black.withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'How it works:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
            SizedBox(height: 2.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStep('1', 'Record a walkthrough video in the app'),
                _buildStep('2', 'Upload your video (CubiCasa workflow)'),
                _buildStep('3', 'Choose white-label option if desired'),
                _buildStep('4', 'Floorplan delivered in 12-14 hours'),
              ],
            ),
            SizedBox(height: 4.h),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.yellow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.yellow.withAlpha(102),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('2D Floorplan feature coming soon!'),
                      backgroundColor: AppTheme.yellow,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Start Floorplan Order',
                  style: GoogleFonts.poppins(
                    color: AppTheme.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: AppTheme.yellow,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  color: AppTheme.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                color: AppTheme.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleJobTap(Map<String, dynamic> job) {
    final property = job['properties'] as Map<String, dynamic>?;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassmorphicContainer(
          opacity: 0.2,
          borderRadius: BorderRadius.circular(24),
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Details',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              _buildJobDetailItem(
                  'Property', property?['address'] ?? 'Unknown'),
              _buildJobDetailItem('Photos', '${job['total_photos'] ?? 0}'),
              _buildJobDetailItem('Status', job['status'] ?? 'Unknown'),
              _buildJobDetailItem(
                  'Price', '\$${job['total_amount'] ?? '0.00'}'),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white.withAlpha(179),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: Text(
                          'View Details',
                          style: GoogleFonts.poppins(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                color: AppTheme.white.withAlpha(179),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: label == 'Price' ? AppTheme.yellow : AppTheme.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleJobLongPress(Map<String, dynamic> job) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Job Actions',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildActionItem('View Details', 'visibility', () {
              Navigator.pop(context);
              _handleJobTap(job);
            }),
            _buildActionItem('Reorder', 'refresh', () {
              Navigator.pop(context);
              _handleReorderTap();
            }),
            _buildActionItem('Share', 'share', () {
              Navigator.pop(context);
              // Handle share
            }),
            _buildActionItem('Delete', 'delete', () {
              Navigator.pop(context);
              // Handle delete
            }),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String title, String iconName, VoidCallback onTap) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.textPrimary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _handleReorderTap() {
    Navigator.pushNamed(context, '/order-summary');
  }

  void _handleTutorialTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tutorial Guides coming soon!'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _handleCalculatorTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pricing Calculator coming soon!'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _handleSupportTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer Support coming soon!'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/new-job-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/job-tracking-notifications');
        break;
      case 3:
        Navigator.pushNamed(context, '/tutorial-guides');
        break;
    }
  }
}
