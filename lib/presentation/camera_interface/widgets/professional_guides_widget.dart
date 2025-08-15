import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfessionalGuidesWidget extends StatelessWidget {
  final bool isVisible;
  final String currentRoom;
  final VoidCallback onClose;

  const ProfessionalGuidesWidget({
    super.key,
    required this.isVisible,
    required this.currentRoom,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 15.h,
      left: 4.w,
      right: 4.w,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentStart,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pro Tips: $currentRoom',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentStart,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ..._getRoomTips(currentRoom)
                .map((tip) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5.h, right: 2.w),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.accentStart,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              tip,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  List<String> _getRoomTips(String room) {
    final Map<String, List<String>> roomTips = {
      'Living Room': [
        'Capture from corner to show room depth and flow',
        'Include natural light sources like windows',
        'Stage furniture to create conversation areas',
        'Use wide angle but avoid distortion at edges',
      ],
      'Kitchen': [
        'Shoot from entrance to show workflow triangle',
        'Highlight countertop space and storage',
        'Turn on under-cabinet lighting for warmth',
        'Include appliances and island seating',
      ],
      'Bedroom': [
        'Position bed as focal point with clear pathways',
        'Show closet space and natural lighting',
        'Include bedside tables and seating areas',
        'Capture view from windows if attractive',
      ],
      'Bathroom': [
        'Show vanity, toilet, and shower/tub in one shot',
        'Turn on all lights including vanity lighting',
        'Include storage solutions and counter space',
        'Highlight tile work and fixtures',
      ],
      'Exterior': [
        'Shoot during golden hour for best lighting',
        'Include landscaping and curb appeal elements',
        'Show driveway, walkways, and entry points',
        'Capture architectural details and rooflines',
      ],
    };

    return roomTips[room] ??
        [
          'Use natural light when possible',
          'Keep camera level and steady',
          'Show room flow and functionality',
          'Highlight unique features and details',
        ];
  }
}
