import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class GuidanceOverlayWidget extends StatefulWidget {
  final int currentStep;
  final List<String> steps;
  final String currentRoom;
  final VoidCallback onStepNext;
  final VoidCallback onClose;

  const GuidanceOverlayWidget({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.currentRoom,
    required this.onStepNext,
    required this.onClose,
  });

  @override
  State<GuidanceOverlayWidget> createState() => _GuidanceOverlayWidgetState();
}

class _GuidanceOverlayWidgetState extends State<GuidanceOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 4.w,
      right: 4.w,
      top: 25.h,
      child: GlassmorphicContainer(
        opacity: 0.2,
        borderRadius: BorderRadius.circular(16),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              children: [
                Icon(
                  Icons.camera_alt,
                  color: AppTheme.yellow,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recording Guide',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.currentRoom,
                        style: GoogleFonts.poppins(
                          color: AppTheme.yellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Current step with animated arrow
            Row(
              children: [
                AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_arrowAnimation.value, 0),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppTheme.yellow,
                        size: 5.w,
                      ),
                    );
                  },
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    widget.steps[widget.currentStep],
                    style: GoogleFonts.poppins(
                      color: AppTheme.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Step indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.steps.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: index == widget.currentStep
                        ? AppTheme.yellow
                        : AppTheme.white.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Navigation buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onStepNext,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Next Tip',
                            style: GoogleFonts.poppins(
                              color: AppTheme.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.arrow_forward,
                            color: AppTheme.black,
                            size: 4.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Additional tips
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.white.withAlpha(13),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.white.withAlpha(26),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppTheme.yellow,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Pro Tips',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• Hold phone steady and move slowly\n'
                    '• Capture all corners and doorways\n'
                    '• Record in good lighting conditions\n'
                    '• Keep phone at waist height',
                    style: GoogleFonts.poppins(
                      color: AppTheme.white.withAlpha(179),
                      fontSize: 11,
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
    );
  }
}
