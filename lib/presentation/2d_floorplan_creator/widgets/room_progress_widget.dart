import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class RoomProgressWidget extends StatelessWidget {
  final int currentRoom;
  final int totalRooms;
  final String currentRoomType;
  final bool isRecording;
  final bool isPaused;
  final Duration recordingDuration;

  const RoomProgressWidget({
    super.key,
    required this.currentRoom,
    required this.totalRooms,
    required this.currentRoomType,
    required this.isRecording,
    required this.isPaused,
    required this.recordingDuration,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      opacity: 0.15,
      borderRadius: BorderRadius.circular(0),
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room counter and type
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.yellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$currentRoom of $totalRooms',
                  style: GoogleFonts.poppins(
                    color: AppTheme.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  currentRoomType,
                  style: GoogleFonts.poppins(
                    color: AppTheme.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isRecording)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isPaused ? Colors.orange : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isPaused ? 'PAUSED' : 'REC',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Row(
            children: List.generate(totalRooms, (index) {
              final roomNumber = index + 1;
              final isCompleted = roomNumber < currentRoom;
              final isCurrent = roomNumber == currentRoom;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < totalRooms - 1 ? 1.w : 0,
                  ),
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.yellow
                        : isCurrent
                            ? AppTheme.yellow.withAlpha(128)
                            : AppTheme.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 2.h),

          // Recording timer and instructions
          Row(
            children: [
              if (isRecording)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.white.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.white.withAlpha(51),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _formatDuration(recordingDuration),
                    style: GoogleFonts.poppins(
                      color: AppTheme.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (isRecording) SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  isRecording
                      ? (isPaused
                          ? 'Recording paused - tap to continue'
                          : 'Walk slowly around the room perimeter')
                      : 'Tap record to start capturing this room',
                  style: GoogleFonts.poppins(
                    color: AppTheme.white.withAlpha(179),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
