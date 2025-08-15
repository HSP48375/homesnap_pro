import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class RecordingControlsWidget extends StatelessWidget {
  final bool isRecording;
  final bool isPaused;
  final Duration recordingDuration;
  final int currentRoom;
  final int totalRooms;
  final bool isUploading;
  final AnimationController pulseController;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback onPauseRecording;
  final VoidCallback onCompleteFloorplan;

  const RecordingControlsWidget({
    super.key,
    required this.isRecording,
    required this.isPaused,
    required this.recordingDuration,
    required this.currentRoom,
    required this.totalRooms,
    required this.isUploading,
    required this.pulseController,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onPauseRecording,
    required this.onCompleteFloorplan,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      opacity: 0.15,
      borderRadius: BorderRadius.circular(0),
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Main record button
          GestureDetector(
            onTap: isUploading
                ? null
                : isRecording
                    ? onStopRecording
                    : onStartRecording,
            child: AnimatedBuilder(
              animation: pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRecording && !isPaused
                      ? 1.0 + (pulseController.value * 0.1)
                      : 1.0,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: isUploading
                          ? AppTheme.yellow.withAlpha(128)
                          : isRecording
                              ? Colors.red
                              : AppTheme.yellow,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.white.withAlpha(77),
                        width: 3,
                      ),
                      boxShadow: [
                        if (isRecording && !isPaused)
                          BoxShadow(
                            color: Colors.red.withAlpha(77),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                      ],
                    ),
                    child: Icon(
                      isUploading
                          ? Icons.cloud_upload
                          : isRecording
                              ? Icons.stop
                              : Icons.videocam,
                      color: isUploading
                          ? AppTheme.black.withAlpha(128)
                          : isRecording
                              ? Colors.white
                              : AppTheme.black,
                      size: 8.w,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 3.h),

          // Control buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Pause/Resume button
              if (isRecording)
                _buildControlButton(
                  icon: isPaused ? Icons.play_arrow : Icons.pause,
                  label: isPaused ? 'Resume' : 'Pause',
                  onTap: isUploading ? null : onPauseRecording,
                  color: isPaused ? AppTheme.yellow : AppTheme.white,
                ),

              // Complete room button
              if (isRecording)
                _buildControlButton(
                  icon: Icons.check_circle,
                  label: 'Complete Room',
                  onTap: isUploading ? null : onStopRecording,
                  color: AppTheme.yellow,
                ),

              // Finish all button
              if (!isRecording && currentRoom >= 3)
                _buildControlButton(
                  icon: Icons.done_all,
                  label: 'Finish & Upload',
                  onTap: isUploading ? null : onCompleteFloorplan,
                  color: AppTheme.yellow,
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Status text
          if (isUploading)
            Column(
              children: [
                CircularProgressIndicator(
                  color: AppTheme.yellow,
                  strokeWidth: 2,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Uploading video...',
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.yellow.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.yellow.withAlpha(77),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    color: AppTheme.yellow,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Floorplan will be available in 12–14 hours',
                    style: GoogleFonts.poppins(
                      color: AppTheme.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color:
              color == AppTheme.yellow ? color : AppTheme.white.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                color == AppTheme.yellow ? color : AppTheme.white.withAlpha(51),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color == AppTheme.yellow ? AppTheme.black : color,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: color == AppTheme.yellow ? AppTheme.black : color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
