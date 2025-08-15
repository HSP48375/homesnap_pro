import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class JobTypeSelectorWidget extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeChanged;

  const JobTypeSelectorWidget({
    Key? key,
    required this.selectedType,
    required this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      opacity: 0.1,
      borderRadius: BorderRadius.circular(20),
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_camera,
                color: AppTheme.yellow,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Photography Package',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Job Type Options
          Column(
            children: [
              _buildJobTypeOption(
                type: 'interior',
                title: 'Interior Only',
                description: 'Inside shots, room details, features',
                price: '\$99.99',
                icon: Icons.home_outlined,
              ),
              SizedBox(height: 2.h),
              _buildJobTypeOption(
                type: 'exterior',
                title: 'Exterior Only',
                description: 'Outside shots, yard, curb appeal',
                price: '\$79.99',
                icon: Icons.landscape_outlined,
              ),
              SizedBox(height: 2.h),
              _buildJobTypeOption(
                type: 'full',
                title: 'Full Property',
                description: 'Complete interior & exterior coverage',
                price: '\$149.99',
                icon: Icons.domain_outlined,
                isRecommended: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJobTypeOption({
    required String type,
    required String title,
    required String description,
    required String price,
    required IconData icon,
    bool isRecommended = false,
  }) {
    final bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.yellow.withAlpha(26)
              : AppTheme.white.withAlpha(13),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.yellow : AppTheme.white.withAlpha(51),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Radio Button
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.yellow
                          : AppTheme.white.withAlpha(128),
                      width: 2,
                    ),
                    color: isSelected ? AppTheme.yellow : Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.black,
                            ),
                          ),
                        )
                      : null,
                ),

                SizedBox(width: 4.w),

                // Icon
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.yellow.withAlpha(51)
                        : AppTheme.white.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppTheme.yellow : AppTheme.white,
                    size: 6.w,
                  ),
                ),

                SizedBox(width: 4.w),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              color:
                                  isSelected ? AppTheme.yellow : AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            price,
                            style: GoogleFonts.poppins(
                              color:
                                  isSelected ? AppTheme.yellow : AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: GoogleFonts.poppins(
                          color: AppTheme.white.withAlpha(179),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Recommended Badge
            if (isRecommended)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: GoogleFonts.poppins(
                      color: AppTheme.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
