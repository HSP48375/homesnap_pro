import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class PhotoOrganizationWidget extends StatelessWidget {
  final String sortBy;
  final Function(String) onSortChanged;
  final bool showQualityIndicators;
  final Function(bool) onQualityToggled;
  final int selectedCount;
  final VoidCallback onDeleteSelected;
  final Function(String) onAssignRoom;

  const PhotoOrganizationWidget({
    Key? key,
    required this.sortBy,
    required this.onSortChanged,
    required this.showQualityIndicators,
    required this.onQualityToggled,
    required this.selectedCount,
    required this.onDeleteSelected,
    required this.onAssignRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Sort and Filter Row
          Row(
            children: [
              // Sort Dropdown
              Expanded(
                child: GlassmorphicContainer(
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(12),
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: sortBy,
                      onChanged: (value) => onSortChanged(value!),
                      dropdownColor: AppTheme.backgroundElevated,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppTheme.white,
                        size: 5.w,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'timestamp',
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppTheme.white,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Recent',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'room',
                          child: Row(
                            children: [
                              Icon(
                                Icons.room_preferences,
                                color: AppTheme.white,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Room',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'quality',
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppTheme.white,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Quality',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // Quality Toggle
              GestureDetector(
                onTap: () => onQualityToggled(!showQualityIndicators),
                child: GlassmorphicContainer(
                  opacity: showQualityIndicators ? 0.2 : 0.1,
                  borderRadius: BorderRadius.circular(12),
                  padding: EdgeInsets.all(3.w),
                  child: Icon(
                    showQualityIndicators
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: showQualityIndicators
                        ? AppTheme.yellow
                        : AppTheme.white,
                    size: 5.w,
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // More Options
              GestureDetector(
                onTap: () => _showMoreOptions(context),
                child: GlassmorphicContainer(
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(12),
                  padding: EdgeInsets.all(3.w),
                  child: Icon(
                    Icons.more_vert,
                    color: AppTheme.white,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),

          // Selection Actions
          if (selectedCount > 0) ...[
            SizedBox(height: 2.h),
            GlassmorphicContainer(
              opacity: 0.15,
              borderRadius: BorderRadius.circular(16),
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    '$selectedCount selected',
                    style: GoogleFonts.poppins(
                      color: AppTheme.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),

                  // Room Assignment
                  GestureDetector(
                    onTap: () => _showRoomAssignmentOptions(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.white.withAlpha(51),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.room_preferences,
                            color: AppTheme.white,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Room',
                            style: GoogleFonts.poppins(
                              color: AppTheme.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // Delete Button
                  GestureDetector(
                    onTap: onDeleteSelected,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(51),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Delete',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphicContainer(
        opacity: 0.95,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
              'Photo Organization',
              style: GoogleFonts.poppins(
                color: AppTheme.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 3.h),
            _buildOptionTile(
              context,
              'Select All',
              Icons.select_all,
              () {
                Navigator.pop(context);
                _showMessage(context, 'Select all functionality coming soon!');
              },
            ),
            _buildOptionTile(
              context,
              'Export Photos',
              Icons.download,
              () {
                Navigator.pop(context);
                _showMessage(context, 'Export functionality coming soon!');
              },
            ),
            _buildOptionTile(
              context,
              'Quality Analysis',
              Icons.analytics,
              () {
                Navigator.pop(context);
                _showMessage(context, 'Quality analysis coming soon!');
              },
            ),
            _buildOptionTile(
              context,
              'Batch Edit',
              Icons.edit,
              () {
                Navigator.pop(context);
                _showMessage(context, 'Batch editing coming soon!');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showRoomAssignmentOptions(BuildContext context) {
    final rooms = [
      {'key': 'living_room', 'name': 'Living Room', 'icon': Icons.living},
      {'key': 'kitchen', 'name': 'Kitchen', 'icon': Icons.kitchen},
      {'key': 'bedroom', 'name': 'Bedroom', 'icon': Icons.bed},
      {'key': 'bathroom', 'name': 'Bathroom', 'icon': Icons.bathroom},
      {'key': 'exterior', 'name': 'Exterior', 'icon': Icons.home},
      {'key': 'uncategorized', 'name': 'Uncategorized', 'icon': Icons.photo},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => GlassmorphicContainer(
        opacity: 0.95,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
              'Assign to Room',
              style: GoogleFonts.poppins(
                color: AppTheme.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Assign $selectedCount selected photos to:',
              style: GoogleFonts.poppins(
                color: AppTheme.black.withAlpha(179),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 3.h),
            Column(
              children: rooms
                  .map((room) => ListTile(
                        leading: Icon(
                          room['icon'] as IconData,
                          color: AppTheme.black,
                          size: 6.w,
                        ),
                        title: Text(
                          room['name'] as String,
                          style: GoogleFonts.poppins(
                            color: AppTheme.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          onAssignRoom(room['key'] as String);
                          Navigator.pop(context);
                          _showMessage(
                              context, 'Photos assigned to ${room['name']}');
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.black,
        size: 6.w,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: AppTheme.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.yellow,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
