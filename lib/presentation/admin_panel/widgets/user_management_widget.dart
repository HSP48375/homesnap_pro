import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class UserManagementWidget extends StatefulWidget {
  const UserManagementWidget({super.key});

  @override
  State<UserManagementWidget> createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'user_001',
      'name': 'Sarah Johnson',
      'email': 'sarah.j@realty.com',
      'role': 'agent',
      'status': 'active',
      'subscription': 'premium',
      'totalJobs': 87,
      'totalSpent': 2449.85,
      'lastActive': '2025-07-22 10:30',
      'joinDate': '2024-03-15',
    },
    {
      'id': 'user_002',
      'name': 'Michael Chen',
      'email': 'mchen@homesales.com',
      'role': 'agent',
      'status': 'active',
      'subscription': 'basic',
      'totalJobs': 156,
      'totalSpent': 4892.50,
      'lastActive': '2025-07-22 11:15',
      'joinDate': '2024-01-08',
    },
    {
      'id': 'user_003',
      'name': 'Emma Rodriguez',
      'email': 'emma.r@luxuryprops.com',
      'role': 'agent',
      'status': 'suspended',
      'subscription': 'premium',
      'totalJobs': 23,
      'totalSpent': 567.30,
      'lastActive': '2025-07-15 09:22',
      'joinDate': '2024-06-20',
    },
    {
      'id': 'user_004',
      'name': 'David Kim',
      'email': 'david@mountainviewrealty.com',
      'role': 'admin',
      'status': 'active',
      'subscription': 'admin',
      'totalJobs': 245,
      'totalSpent': 0.00,
      'lastActive': '2025-07-22 12:00',
      'joinDate': '2023-11-01',
    },
  ];

  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _getFilteredUsers();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with search and filter
          GlassmorphicContainer(
            opacity: 0.1,
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: AppTheme.yellow,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'User Management',
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
                        '${_users.length} Users',
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

                // Search and Filter
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.white.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: AppTheme.white.withAlpha(51)),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: GoogleFonts.poppins(
                              color: AppTheme.white, fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Search users...',
                            hintStyle: GoogleFonts.poppins(
                                color: AppTheme.white.withAlpha(128),
                                fontSize: 12),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search,
                                color: AppTheme.white.withAlpha(128),
                                size: 5.w),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: _buildFilterDropdown(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // User Stats
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Active',
                      _users.where((u) => u['status'] == 'active').length,
                      Colors.green)),
              SizedBox(width: 2.w),
              Expanded(
                  child: _buildStatCard(
                      'Suspended',
                      _users.where((u) => u['status'] == 'suspended').length,
                      Colors.red)),
              SizedBox(width: 2.w),
              Expanded(
                  child: _buildStatCard(
                      'Premium',
                      _users
                          .where((u) => u['subscription'] == 'premium')
                          .length,
                      AppTheme.yellow)),
              SizedBox(width: 2.w),
              Expanded(
                  child: _buildStatCard(
                      'Admins',
                      _users.where((u) => u['role'] == 'admin').length,
                      Colors.purple)),
            ],
          ),

          SizedBox(height: 3.h),

          // Users List
          ...filteredUsers.map((user) => _buildUserCard(user)),

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
            DropdownMenuItem(value: 'all', child: Text('All Users')),
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'suspended', child: Text('Suspended')),
            DropdownMenuItem(value: 'premium', child: Text('Premium')),
            DropdownMenuItem(value: 'admin', child: Text('Admins')),
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

  Widget _buildUserCard(Map<String, dynamic> user) {
    Color statusColor = user['status'] == 'active' ? Colors.green : Colors.red;
    Color subscriptionColor = user['subscription'] == 'premium'
        ? AppTheme.yellow
        : user['subscription'] == 'admin'
            ? Colors.purple
            : Colors.grey;

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
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    user['name'][0].toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: AppTheme.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: GoogleFonts.poppins(
                        color: AppTheme.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      user['email'],
                      style: GoogleFonts.poppins(
                        color: AppTheme.white.withAlpha(179),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      user['status'].toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: AppTheme.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: subscriptionColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: subscriptionColor),
                    ),
                    child: Text(
                      user['subscription'].toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: subscriptionColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildUserStat('Jobs', user['totalJobs'].toString()),
              ),
              Expanded(
                child: _buildUserStat(
                    'Spent', '\$${user['totalSpent'].toStringAsFixed(2)}'),
              ),
              Expanded(
                child: _buildUserStat('Role', user['role'].toUpperCase()),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(Icons.schedule,
                  color: AppTheme.white.withAlpha(128), size: 4.w),
              SizedBox(width: 2.w),
              Text(
                'Last active: ${user['lastActive']}',
                style: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(179),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                'Joined: ${user['joinDate']}',
                style: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(179),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildActionButton(
                  'View Profile', Icons.person, () => _viewUserProfile(user)),
              SizedBox(width: 2.w),
              _buildActionButton('Edit', Icons.edit, () => _editUser(user)),
              SizedBox(width: 2.w),
              _buildActionButton(
                user['status'] == 'active' ? 'Suspend' : 'Activate',
                user['status'] == 'active' ? Icons.block : Icons.check_circle,
                () => _toggleUserStatus(user),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppTheme.yellow,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppTheme.white.withAlpha(179),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.yellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    List<Map<String, dynamic>> filtered = _users;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            user['email'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply status/type filter
    switch (_selectedFilter) {
      case 'active':
        filtered =
            filtered.where((user) => user['status'] == 'active').toList();
        break;
      case 'suspended':
        filtered =
            filtered.where((user) => user['status'] == 'suspended').toList();
        break;
      case 'premium':
        filtered = filtered
            .where((user) => user['subscription'] == 'premium')
            .toList();
        break;
      case 'admin':
        filtered = filtered.where((user) => user['role'] == 'admin').toList();
        break;
    }

    return filtered;
  }

  void _viewUserProfile(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing profile for ${user['name']}'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _editUser(Map<String, dynamic> user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${user['name']}'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['status'] = user['status'] == 'active' ? 'suspended' : 'active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${user['name']} ${user['status'] == 'active' ? 'activated' : 'suspended'}'),
        backgroundColor: AppTheme.yellow,
      ),
    );
  }
}
