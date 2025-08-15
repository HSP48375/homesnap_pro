import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class JobQueueWidget extends StatefulWidget {
  const JobQueueWidget({super.key});

  @override
  State<JobQueueWidget> createState() => _JobQueueWidgetState();
}

class _JobQueueWidgetState extends State<JobQueueWidget> {
  final List<Map<String, dynamic>> _jobs = [
    {
      'id': '1247',
      'property': '123 Sunset Boulevard, Beverly Hills',
      'user': 'Sarah Johnson',
      'service': 'Photo Editing + Virtual Staging',
      'status': 'processing',
      'priority': 'high',
      'photos': 24,
      'amount': 149.99,
      'created': '2025-07-22 10:30',
      'deadline': '2025-07-22 16:30',
    },
    {
      'id': '1248',
      'property': '456 Ocean Drive, Miami Beach',
      'user': 'Michael Chen',
      'service': 'Twilight Photo + Item Removal',
      'status': 'pending',
      'priority': 'medium',
      'photos': 18,
      'amount': 199.99,
      'created': '2025-07-22 11:15',
      'deadline': '2025-07-22 17:15',
    },
    {
      'id': '1249',
      'property': '789 Lake View Drive, Austin',
      'user': 'Emma Rodriguez',
      'service': '2D Floorplan + Photo Branding',
      'status': 'completed',
      'priority': 'low',
      'photos': 32,
      'amount': 89.50,
      'created': '2025-07-22 09:00',
      'deadline': '2025-07-22 15:00',
    },
    {
      'id': '1250',
      'property': '321 Mountain View, Denver',
      'user': 'David Kim',
      'service': 'Virtual Staging',
      'status': 'failed',
      'priority': 'high',
      'photos': 15,
      'amount': 299.99,
      'created': '2025-07-22 08:45',
      'deadline': '2025-07-22 14:45',
    },
  ];

  String _selectedFilter = 'all';
  String _selectedSort = 'deadline';

  @override
  Widget build(BuildContext context) {
    final filteredJobs = _getFilteredJobs();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with filters
          GlassmorphicContainer(
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.work_history,
                      color: AppTheme.yellow,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Job Queue Management',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_jobs.where((j) => j['status'] == 'processing' || j['status'] == 'pending').length} Active',
                        style: GoogleFonts.poppins(
                          color: AppTheme.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Filters
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildSortDropdown(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Job Stats
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Processing',
                      _jobs.where((j) => j['status'] == 'processing').length,
                      Colors.orange)),
              SizedBox(width: 2.w),
              Expanded(
                  child: _buildStatCard(
                      'Pending',
                      _jobs.where((j) => j['status'] == 'pending').length,
                      AppTheme.yellow)),
              SizedBox(width: 2.w),
              Expanded(
                  child: _buildStatCard(
                      'Completed',
                      _jobs.where((j) => j['status'] == 'completed').length,
                      Colors.green)),
              SizedBox(width: 2.w),
              Expanded(
                  child: _buildStatCard(
                      'Failed',
                      _jobs.where((j) => j['status'] == 'failed').length,
                      Colors.red)),
            ],
          ),

          SizedBox(height: 3.h),

          // Jobs List
          ...filteredJobs.map((job) => _buildJobCard(job)),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.white.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.white.withAlpha(51)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          isExpanded: true,
          dropdownColor: AppTheme.backgroundElevated,
          style: GoogleFonts.poppins(color: AppTheme.white, fontSize: 12),
          onChanged: (value) {
            setState(() {
              _selectedFilter = value!;
            });
          },
          items: [
            DropdownMenuItem(value: 'all', child: Text('All Jobs')),
            DropdownMenuItem(value: 'processing', child: Text('Processing')),
            DropdownMenuItem(value: 'pending', child: Text('Pending')),
            DropdownMenuItem(value: 'completed', child: Text('Completed')),
            DropdownMenuItem(value: 'failed', child: Text('Failed')),
          ],
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.white.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.white.withAlpha(51)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSort,
          isExpanded: true,
          dropdownColor: AppTheme.backgroundElevated,
          style: GoogleFonts.poppins(color: AppTheme.white, fontSize: 12),
          onChanged: (value) {
            setState(() {
              _selectedSort = value!;
            });
          },
          items: [
            DropdownMenuItem(value: 'deadline', child: Text('By Deadline')),
            DropdownMenuItem(value: 'priority', child: Text('By Priority')),
            DropdownMenuItem(value: 'amount', child: Text('By Amount')),
            DropdownMenuItem(value: 'created', child: Text('By Created Date')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.white.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.white.withAlpha(51)),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppTheme.white.withAlpha(179),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    Color statusColor = _getStatusColor(job['status']);
    Color priorityColor = _getPriorityColor(job['priority']);

    return GlassmorphicContainer(
      opacity: 0.1,
      borderRadius: BorderRadius.circular(12),
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job['status'].toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: AppTheme.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: priorityColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: priorityColor),
                ),
                child: Text(
                  '${job['priority']} PRIORITY',
                  style: GoogleFonts.poppins(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Job #${job['id']}',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            job['property'],
            style: GoogleFonts.poppins(
              color: AppTheme.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Icon(Icons.person,
                  color: AppTheme.white.withAlpha(128), size: 4.w),
              SizedBox(width: 2.w),
              Text(
                job['user'],
                style: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(179),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.photo_camera,
                  color: AppTheme.white.withAlpha(128), size: 4.w),
              SizedBox(width: 2.w),
              Text(
                '${job['photos']} photos',
                style: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(179),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            job['service'],
            style: GoogleFonts.poppins(
              color: AppTheme.yellow,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deadline: ${job['deadline']}',
                      style: GoogleFonts.poppins(
                        color: AppTheme.white.withAlpha(179),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '\$${job['amount'].toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: AppTheme.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildActionButton(
                      'View', Icons.visibility, () => _showJobDetails(job)),
                  SizedBox(width: 2.w),
                  _buildActionButton('Edit', Icons.edit, () => _editJob(job)),
                  if (job['status'] == 'failed') ...[
                    SizedBox(width: 2.w),
                    _buildActionButton(
                        'Retry', Icons.refresh, () => _retryJob(job)),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.yellow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.black, size: 4.w),
            SizedBox(width: 1.w),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: AppTheme.black,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'processing':
        return Colors.orange;
      case 'pending':
        return AppTheme.yellow;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return AppTheme.white;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return AppTheme.white;
    }
  }

  List<Map<String, dynamic>> _getFilteredJobs() {
    List<Map<String, dynamic>> filtered = _selectedFilter == 'all'
        ? _jobs
        : _jobs.where((job) => job['status'] == _selectedFilter).toList();

    filtered.sort((a, b) {
      switch (_selectedSort) {
        case 'priority':
          final priorities = {'high': 3, 'medium': 2, 'low': 1};
          return (priorities[b['priority']] ?? 0)
              .compareTo(priorities[a['priority']] ?? 0);
        case 'amount':
          return (b['amount'] as double).compareTo(a['amount'] as double);
        case 'created':
          return b['created'].compareTo(a['created']);
        default: // deadline
          return a['deadline'].compareTo(b['deadline']);
      }
    });

    return filtered;
  }

  void _showJobDetails(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing details for Job #${job['id']}'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _editJob(Map<String, dynamic> job) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing Job #${job['id']}'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _retryJob(Map<String, dynamic> job) {
    setState(() {
      job['status'] = 'pending';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Job #${job['id']} added back to queue'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }
}
