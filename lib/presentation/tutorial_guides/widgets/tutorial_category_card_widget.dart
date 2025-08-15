import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../tutorial_guides.dart';

class TutorialCategoryCard extends StatelessWidget {
  final TutorialCategory category;
  final bool isLight;
  final VoidCallback onTap;

  const TutorialCategoryCard({
    super.key,
    required this.category,
    required this.isLight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tutorialCount = category.tutorials.length;
    final newTutorialsCount = category.tutorials.where((t) => t.isNew).length;

    return GlassmorphicContainer(
      padding: EdgeInsets.all(4.w),
      isLight: isLight,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and new badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: category.color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 6.w,
                ),
              ),
              if (newTutorialsCount > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'NEW',
                    style: GoogleFonts.poppins(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.black,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 3.w),

          // Category title
          Text(
            category.title,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isLight ? AppTheme.black : AppTheme.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.w),

          // Category description
          Text(
            category.description,
            style: GoogleFonts.poppins(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color:
                  isLight ? AppTheme.textSecondary : AppTheme.textSecondaryDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          Spacer(),

          // Stats and info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: AppTheme.yellow,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    category.estimatedTime,
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.yellow,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.w),
              Row(
                children: [
                  Icon(
                    Icons.signal_cellular_alt,
                    color: isLight
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryDark,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    category.difficultyLevel,
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: isLight
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.w),
              Row(
                children: [
                  Icon(
                    Icons.video_library,
                    color: isLight
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryDark,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '$tutorialCount tutorials',
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: isLight
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryDark,
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
}
