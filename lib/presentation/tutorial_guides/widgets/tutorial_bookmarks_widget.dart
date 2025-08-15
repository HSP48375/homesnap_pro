import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../tutorial_guides.dart';

class TutorialBookmarks extends StatelessWidget {
  final List<Tutorial> bookmarkedTutorials;
  final bool isLight;
  final Function(Tutorial) onTutorialTap;
  final Function(Tutorial) onRemoveBookmark;

  const TutorialBookmarks({
    super.key,
    required this.bookmarkedTutorials,
    required this.isLight,
    required this.onTutorialTap,
    required this.onRemoveBookmark,
  });

  @override
  Widget build(BuildContext context) {
    if (bookmarkedTutorials.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: 4.w),
          ...bookmarkedTutorials
              .map((tutorial) => _buildBookmarkedTutorial(tutorial)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 20.w,
            color: isLight
                ? AppTheme.textSecondary.withAlpha(128)
                : AppTheme.textSecondaryDark.withAlpha(128),
          ),
          SizedBox(height: 4.w),
          Text(
            'No Bookmarked Tutorials',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color:
                  isLight ? AppTheme.textSecondary : AppTheme.textSecondaryDark,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            'Bookmark tutorials to access them quickly later',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color:
                  isLight ? AppTheme.textSecondary : AppTheme.textSecondaryDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookmarked Tutorials',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isLight ? AppTheme.black : AppTheme.white,
              ),
            ),
            Text(
              '${bookmarkedTutorials.length} tutorial${bookmarkedTutorials.length != 1 ? 's' : ''}',
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: isLight
                    ? AppTheme.textSecondary
                    : AppTheme.textSecondaryDark,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.yellow.withAlpha(51),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.yellow),
          ),
          child: Icon(
            Icons.bookmark,
            color: AppTheme.yellow,
            size: 5.w,
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkedTutorial(Tutorial tutorial) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      child: GlassmorphicContainer(
        padding: EdgeInsets.all(4.w),
        isLight: isLight,
        onTap: () => onTutorialTap(tutorial),
        child: Row(
          children: [
            // Thumbnail
            Stack(
              children: [
                Container(
                  width: 20.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.play_circle_filled,
                    color: AppTheme.black,
                    size: 8.w,
                  ),
                ),
                if (tutorial.isNew)
                  Positioned(
                    top: -1.w,
                    right: -1.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w, vertical: 0.5.w),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(8),
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
                  ),
              ],
            ),
            SizedBox(width: 4.w),

            // Tutorial info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutorial.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isLight ? AppTheme.black : AppTheme.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.w),
                  Text(
                    tutorial.description,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: isLight
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tutorial.duration,
                      style: GoogleFonts.poppins(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.yellow,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                GestureDetector(
                  onTap: () => onTutorialTap(tutorial),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: AppTheme.black,
                      size: 4.w,
                    ),
                  ),
                ),
                SizedBox(height: 2.w),
                GestureDetector(
                  onTap: () => onRemoveBookmark(tutorial),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isLight
                          ? AppTheme.borderSubtle
                          : AppTheme.textSecondaryDark.withAlpha(51),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.bookmark_remove,
                      color: isLight
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryDark,
                      size: 4.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
