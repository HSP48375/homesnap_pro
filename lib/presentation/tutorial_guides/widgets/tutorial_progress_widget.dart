import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../tutorial_guides.dart';

class TutorialProgress extends StatelessWidget {
  final List<TutorialCategory> tutorialCategories;
  final Map<String, double> tutorialProgress;
  final bool isLight;

  const TutorialProgress({
    super.key,
    required this.tutorialCategories,
    required this.tutorialProgress,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final totalTutorials = tutorialCategories.fold<int>(
        0, (sum, category) => sum + category.tutorials.length);
    final completedTutorials =
        tutorialProgress.values.where((progress) => progress >= 1.0).length;
    final overallProgress =
        totalTutorials > 0 ? completedTutorials / totalTutorials : 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Overall progress card
          _buildOverallProgressCard(
              overallProgress, completedTutorials, totalTutorials),
          SizedBox(height: 4.w),

          // Achievement badges
          _buildAchievementBadges(),
          SizedBox(height: 4.w),

          // Category progress
          ...tutorialCategories
              .map((category) => _buildCategoryProgress(category))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildOverallProgressCard(
      double overallProgress, int completed, int total) {
    return GlassmorphicContainer(
      padding: EdgeInsets.all(6.w),
      isLight: isLight,
      child: Column(
        children: [
          Text(
            'Overall Progress',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isLight ? AppTheme.black : AppTheme.white,
            ),
          ),
          SizedBox(height: 4.w),

          // Circular progress indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 30.w,
                height: 30.w,
                child: CircularProgressIndicator(
                  value: overallProgress,
                  strokeWidth: 8,
                  backgroundColor: isLight
                      ? AppTheme.borderSubtle
                      : AppTheme.textSecondaryDark.withAlpha(77),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yellow),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${(overallProgress * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: isLight ? AppTheme.black : AppTheme.white,
                    ),
                  ),
                  Text(
                    'Complete',
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
            ],
          ),
          SizedBox(height: 4.w),

          Text(
            '$completed of $total tutorials completed',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color:
                  isLight ? AppTheme.textSecondary : AppTheme.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadges() {
    final achievements = _getAchievements();

    return GlassmorphicContainer(
      padding: EdgeInsets.all(6.w),
      isLight: isLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievement Badges',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: isLight ? AppTheme.black : AppTheme.white,
            ),
          ),
          SizedBox(height: 3.w),
          Wrap(
            spacing: 3.w,
            runSpacing: 3.w,
            children: achievements
                .map((achievement) => _buildAchievementBadge(achievement))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(Achievement achievement) {
    return Container(
      width: 25.w,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? AppTheme.yellow.withAlpha(51)
            : (isLight
                ? AppTheme.borderSubtle
                : AppTheme.textSecondaryDark.withAlpha(26)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppTheme.yellow
              : (isLight ? AppTheme.borderSubtle : AppTheme.textSecondaryDark),
        ),
      ),
      child: Column(
        children: [
          Icon(
            achievement.icon,
            color: achievement.isUnlocked
                ? AppTheme.yellow
                : (isLight
                    ? AppTheme.textSecondary
                    : AppTheme.textSecondaryDark),
            size: 8.w,
          ),
          SizedBox(height: 1.w),
          Text(
            achievement.title,
            style: GoogleFonts.poppins(
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
              color: achievement.isUnlocked
                  ? (isLight ? AppTheme.black : AppTheme.white)
                  : (isLight
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryDark),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(TutorialCategory category) {
    final categoryTutorials = category.tutorials;
    final categoryCompleted = categoryTutorials
        .where((tutorial) => (tutorialProgress[tutorial.id] ?? 0.0) >= 1.0)
        .length;
    final categoryProgress = categoryTutorials.isNotEmpty
        ? categoryCompleted / categoryTutorials.length
        : 0.0;

    return Container(
      margin: EdgeInsets.only(bottom: 3.w),
      child: GlassmorphicContainer(
        padding: EdgeInsets.all(4.w),
        isLight: isLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: category.color.withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 4.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    category.title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isLight ? AppTheme.black : AppTheme.white,
                    ),
                  ),
                ),
                Text(
                  '$categoryCompleted/${categoryTutorials.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: isLight
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.w),

            // Progress bar
            Container(
              height: 2.w,
              decoration: BoxDecoration(
                color: isLight
                    ? AppTheme.borderSubtle
                    : AppTheme.textSecondaryDark.withAlpha(77),
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: categoryProgress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.w),

            Text(
              '${(categoryProgress * 100).toInt()}% Complete',
              style: GoogleFonts.poppins(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Achievement> _getAchievements() {
    final totalCompleted =
        tutorialProgress.values.where((progress) => progress >= 1.0).length;

    return [
      Achievement(
        title: 'First Steps',
        icon: Icons.play_arrow,
        isUnlocked: totalCompleted >= 1,
      ),
      Achievement(
        title: 'Getting Started',
        icon: Icons.school,
        isUnlocked: totalCompleted >= 3,
      ),
      Achievement(
        title: 'Learning Pro',
        icon: Icons.star,
        isUnlocked: totalCompleted >= 10,
      ),
      Achievement(
        title: 'Master',
        icon: Icons.emoji_events,
        isUnlocked: totalCompleted >= 20,
      ),
      Achievement(
        title: 'Camera Expert',
        icon: Icons.camera_alt,
        isUnlocked: _isCategoryCompleted('camera_basics'),
      ),
      Achievement(
        title: 'Property Pro',
        icon: Icons.home,
        isUnlocked: _isCategoryCompleted('property_photography'),
      ),
    ];
  }

  bool _isCategoryCompleted(String categoryId) {
    final category = tutorialCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => TutorialCategory(
        id: '',
        title: '',
        description: '',
        icon: Icons.error,
        color: AppTheme.black,
        estimatedTime: '',
        difficultyLevel: '',
        tutorials: [],
      ),
    );

    return category.tutorials
        .every((tutorial) => (tutorialProgress[tutorial.id] ?? 0.0) >= 1.0);
  }
}

class Achievement {
  final String title;
  final IconData icon;
  final bool isUnlocked;

  Achievement({
    required this.title,
    required this.icon,
    required this.isUnlocked,
  });
}
