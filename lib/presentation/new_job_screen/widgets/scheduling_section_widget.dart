import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class SchedulingSectionWidget extends StatelessWidget {
  final bool isImmediate;
  final DateTime? scheduledDate;
  final Function({bool? isImmediate, DateTime? scheduledDate})
      onSchedulingChanged;

  const SchedulingSectionWidget({
    Key? key,
    required this.isImmediate,
    required this.scheduledDate,
    required this.onSchedulingChanged,
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
                Icons.schedule,
                color: AppTheme.yellow,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Scheduling',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Immediate Capture Option
          GestureDetector(
            onTap: () => onSchedulingChanged(isImmediate: true),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isImmediate
                    ? AppTheme.yellow.withAlpha(26)
                    : AppTheme.white.withAlpha(13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isImmediate
                      ? AppTheme.yellow
                      : AppTheme.white.withAlpha(51),
                  width: isImmediate ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Radio Button
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isImmediate
                            ? AppTheme.yellow
                            : AppTheme.white.withAlpha(128),
                        width: 2,
                      ),
                      color: isImmediate ? AppTheme.yellow : Colors.transparent,
                    ),
                    child: isImmediate
                        ? Center(
                            child: Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.black,
                              ),
                            ),
                          )
                        : null,
                  ),

                  SizedBox(width: 4.w),

                  // Icon and Content
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isImmediate
                          ? AppTheme.yellow.withAlpha(51)
                          : AppTheme.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.flash_on,
                      color: isImmediate ? AppTheme.yellow : AppTheme.white,
                      size: 5.w,
                    ),
                  ),

                  SizedBox(width: 4.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Now',
                          style: GoogleFonts.poppins(
                            color:
                                isImmediate ? AppTheme.yellow : AppTheme.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Begin photography immediately',
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
          ),

          SizedBox(height: 2.h),

          // Schedule for Later Option
          GestureDetector(
            onTap: () => onSchedulingChanged(isImmediate: false),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: !isImmediate
                    ? AppTheme.yellow.withAlpha(26)
                    : AppTheme.white.withAlpha(13),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !isImmediate
                      ? AppTheme.yellow
                      : AppTheme.white.withAlpha(51),
                  width: !isImmediate ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  // Radio Button
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: !isImmediate
                            ? AppTheme.yellow
                            : AppTheme.white.withAlpha(128),
                        width: 2,
                      ),
                      color:
                          !isImmediate ? AppTheme.yellow : Colors.transparent,
                    ),
                    child: !isImmediate
                        ? Center(
                            child: Container(
                              width: 2.w,
                              height: 2.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.black,
                              ),
                            ),
                          )
                        : null,
                  ),

                  SizedBox(width: 4.w),

                  // Icon and Content
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: !isImmediate
                          ? AppTheme.yellow.withAlpha(51)
                          : AppTheme.white.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today,
                      color: !isImmediate ? AppTheme.yellow : AppTheme.white,
                      size: 5.w,
                    ),
                  ),

                  SizedBox(width: 4.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule Later',
                          style: GoogleFonts.poppins(
                            color:
                                !isImmediate ? AppTheme.yellow : AppTheme.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          scheduledDate != null
                              ? 'Scheduled for ${_formatDate(scheduledDate!)}'
                              : 'Choose a date and time',
                          style: GoogleFonts.poppins(
                            color: AppTheme.white.withAlpha(179),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!isImmediate)
                    GestureDetector(
                      onTap: () => _selectDateTime(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Select',
                          style: GoogleFonts.poppins(
                            color: AppTheme.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (!isImmediate && scheduledDate != null) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.yellow.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppTheme.yellow.withAlpha(51), width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.yellow,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Processing may take 48-72 hours for scheduled jobs',
                      style: GoogleFonts.poppins(
                        color: AppTheme.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.yellow,
              onPrimary: AppTheme.black,
              surface: AppTheme.backgroundElevated,
              onSurface: AppTheme.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppTheme.yellow,
                onPrimary: AppTheme.black,
                surface: AppTheme.backgroundElevated,
                onSurface: AppTheme.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime scheduledDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        onSchedulingChanged(scheduledDate: scheduledDateTime);
      }
    }
  }

  String _formatDate(DateTime date) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final String month = months[date.month - 1];
    final String day = date.day.toString();
    final String hour =
        date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString();
    final String minute = date.minute.toString().padLeft(2, '0');
    final String ampm = date.hour >= 12 ? 'PM' : 'AM';

    return '$month $day at $hour:$minute $ampm';
  }
}
