import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class PhotoCountEstimatorWidget extends StatelessWidget {
  final int estimatedPhotos;
  final String jobType;

  const PhotoCountEstimatorWidget({
    Key? key,
    required this.estimatedPhotos,
    required this.jobType,
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
                Icons.photo_library_outlined,
                color: AppTheme.yellow,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Photo Count Estimate',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Estimated Photos Display
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.yellow.withAlpha(26),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.yellow, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppTheme.black,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$estimatedPhotos Photos',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Estimated for ${_getJobTypeDescription(jobType)}',
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
          ),

          SizedBox(height: 3.h),

          // Photo Distribution
          Text(
            'Recommended Shot Distribution',
            style: GoogleFonts.poppins(
              color: AppTheme.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Column(
            children: _buildPhotoDistribution(),
          ),

          SizedBox(height: 3.h),

          // Photo Guidelines
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.white.withAlpha(13),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.white.withAlpha(51),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.yellow,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pro Tips',
                        style: GoogleFonts.poppins(
                          color: AppTheme.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '• Take multiple angles of key rooms\n• Include detail shots of unique features\n• Capture natural lighting when possible\n• Focus on selling points and curb appeal',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white.withAlpha(179),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getJobTypeDescription(String type) {
    switch (type) {
      case 'interior':
        return 'interior photography';
      case 'exterior':
        return 'exterior photography';
      case 'full':
        return 'full property coverage';
      default:
        return 'property photography';
    }
  }

  List<Widget> _buildPhotoDistribution() {
    List<Map<String, dynamic>> distribution = [];

    switch (jobType) {
      case 'interior':
        distribution = [
          {
            'category': 'Living Areas',
            'count': (estimatedPhotos * 0.4).round(),
            'icon': Icons.living
          },
          {
            'category': 'Bedrooms',
            'count': (estimatedPhotos * 0.3).round(),
            'icon': Icons.bed
          },
          {
            'category': 'Bathrooms',
            'count': (estimatedPhotos * 0.2).round(),
            'icon': Icons.bathroom
          },
          {
            'category': 'Kitchen & Dining',
            'count': (estimatedPhotos * 0.1).round(),
            'icon': Icons.kitchen
          },
        ];
        break;
      case 'exterior':
        distribution = [
          {
            'category': 'Front View',
            'count': (estimatedPhotos * 0.4).round(),
            'icon': Icons.home
          },
          {
            'category': 'Backyard',
            'count': (estimatedPhotos * 0.3).round(),
            'icon': Icons.grass
          },
          {
            'category': 'Side Views',
            'count': (estimatedPhotos * 0.2).round(),
            'icon': Icons.help_outline
          },
          {
            'category': 'Details',
            'count': (estimatedPhotos * 0.1).round(),
            'icon': Icons.zoom_in
          },
        ];
        break;
      case 'full':
      default:
        distribution = [
          {
            'category': 'Interior Rooms',
            'count': (estimatedPhotos * 0.5).round(),
            'icon': Icons.living
          },
          {
            'category': 'Exterior Views',
            'count': (estimatedPhotos * 0.3).round(),
            'icon': Icons.home
          },
          {
            'category': 'Detail Shots',
            'count': (estimatedPhotos * 0.2).round(),
            'icon': Icons.zoom_in
          },
        ];
        break;
    }

    return distribution
        .map((item) => _buildDistributionItem(
              item['category'],
              item['count'],
              item['icon'],
            ))
        .toList();
  }

  Widget _buildDistributionItem(String category, int count, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.white.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.white,
              size: 4.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              category,
              style: GoogleFonts.poppins(
                color: AppTheme.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.yellow.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count photos',
              style: GoogleFonts.poppins(
                color: AppTheme.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
