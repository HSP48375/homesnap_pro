import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class CostEstimateWidget extends StatelessWidget {
  final double estimatedCost;
  final String deliveryTimeline;

  const CostEstimateWidget({
    Key? key,
    required this.estimatedCost,
    required this.deliveryTimeline,
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
                Icons.attach_money,
                color: AppTheme.yellow,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Cost Estimate',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Cost Breakdown
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.white.withAlpha(13),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.white.withAlpha(51),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Estimated Cost',
                      style: GoogleFonts.poppins(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${estimatedCost.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        color: AppTheme.yellow,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppTheme.white.withAlpha(179),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Delivery: $deliveryTimeline',
                      style: GoogleFonts.poppins(
                        color: AppTheme.white.withAlpha(179),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Pricing Notes
          Text(
            '• Final price may vary based on actual photo count\n• Additional services available during review\n• Payment processed after completion',
            style: GoogleFonts.poppins(
              color: AppTheme.white.withAlpha(128),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
