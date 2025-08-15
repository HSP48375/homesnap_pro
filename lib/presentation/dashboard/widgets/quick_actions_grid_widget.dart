import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './quick_action_tile_widget.dart';

class QuickActionsGridWidget extends StatelessWidget {
  final VoidCallback onReorderTap;
  final VoidCallback onTutorialTap;
  final VoidCallback onCalculatorTap;
  final VoidCallback onSupportTap;

  const QuickActionsGridWidget({
    super.key,
    required this.onReorderTap,
    required this.onTutorialTap,
    required this.onCalculatorTap,
    required this.onSupportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 3.h,
            childAspectRatio: 1.1,
            children: [
              QuickActionTileWidget(
                title: 'Reorder Previous Job',
                subtitle: 'Quick reorder from history',
                iconName: 'refresh',
                backgroundColor: Colors.blue,
                onTap: onReorderTap,
              ),
              QuickActionTileWidget(
                title: 'Tutorial Guides',
                subtitle: 'Learn pro photography tips',
                iconName: 'school',
                backgroundColor: Colors.green,
                onTap: onTutorialTap,
              ),
              QuickActionTileWidget(
                title: 'Pricing Calculator',
                subtitle: 'Estimate job costs',
                iconName: 'calculate',
                backgroundColor: Colors.orange,
                onTap: onCalculatorTap,
              ),
              QuickActionTileWidget(
                title: 'Customer Support',
                subtitle: 'Get help and assistance',
                iconName: 'support_agent',
                backgroundColor: Colors.purple,
                onTap: onSupportTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
