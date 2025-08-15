import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'dart:async';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class DeliveryMessageWidget extends StatefulWidget {
  final AnimationController animationController;
  final bool isVisible;

  const DeliveryMessageWidget({
    super.key,
    required this.animationController,
    required this.isVisible,
  });

  @override
  State<DeliveryMessageWidget> createState() => _DeliveryMessageWidgetState();
}

class _DeliveryMessageWidgetState extends State<DeliveryMessageWidget>
    with TickerProviderStateMixin {
  late AnimationController _countdownController;
  late Animation<double> _countdownAnimation;
  Duration _remainingTime = Duration(hours: 14);

  @override
  void initState() {
    super.initState();

    _countdownController = AnimationController(
      duration: Duration(hours: 14), // 14 hour countdown
      vsync: this,
    );

    _countdownAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_countdownController);

    if (widget.isVisible) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownController.forward();

    // Update remaining time every minute
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (!mounted || !widget.isVisible) {
        timer.cancel();
        return;
      }

      final elapsed = Duration(
        milliseconds:
            (_countdownController.value * Duration(hours: 14).inMilliseconds)
                .round(),
      );

      setState(() {
        _remainingTime = Duration(hours: 14) - elapsed;
      });

      if (_remainingTime.inMinutes <= 0) {
        timer.cancel();
      }
    });
  }

  String _formatTimeRemaining(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    } else {
      return '${minutes}m remaining';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: AnimatedBuilder(
          animation: widget.animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (widget.animationController.value * 0.2),
              child: Opacity(
                opacity: widget.animationController.value,
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: GlassmorphicContainer(
                    opacity: 0.2,
                    borderRadius: BorderRadius.circular(20),
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success icon
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppTheme.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: AppTheme.black,
                            size: 10.w,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          'Upload Successful!',
                          style: GoogleFonts.poppins(
                            color: AppTheme.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 2.h),

                        Text(
                          'Your video has been processed and uploaded successfully. Our team will now create your professional 2D floorplan.',
                          style: GoogleFonts.poppins(
                            color: AppTheme.white.withAlpha(179),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 4.h),

                        // Delivery time container
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.yellow.withAlpha(38),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.yellow,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: AppTheme.yellow,
                                    size: 6.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Delivery Time',
                                    style: GoogleFonts.poppins(
                                      color: AppTheme.yellow,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h),

                              Text(
                                '12–14 Hours',
                                style: GoogleFonts.poppins(
                                  color: AppTheme.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              SizedBox(height: 1.h),

                              // Countdown progress bar
                              AnimatedBuilder(
                                animation: _countdownAnimation,
                                builder: (context, child) {
                                  return Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: 1.0 - _countdownAnimation.value,
                                        backgroundColor:
                                            AppTheme.white.withAlpha(26),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppTheme.yellow,
                                        ),
                                        minHeight: 6,
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        _formatTimeRemaining(_remainingTime),
                                        style: GoogleFonts.poppins(
                                          color: AppTheme.white.withAlpha(179),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Notification info
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.white.withAlpha(13),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.white.withAlpha(26),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: AppTheme.yellow,
                                size: 5.w,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  'You will receive a notification when your floorplan is ready for download.',
                                  style: GoogleFonts.poppins(
                                    color: AppTheme.white.withAlpha(179),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
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
            );
          },
        ),
      ),
    );
  }
}
