import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({
    Key? key,
    required this.errorDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppTheme.black,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Icon(
                Icons.error_outline,
                color: AppTheme.yellow,
                size: 20.w,
              ),

              SizedBox(height: 4.h),

              // Error Title
              Text(
                'Oops! Something went wrong',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Error Message
              Text(
                'We encountered an unexpected error. Don\'t worry, our team has been notified.',
                style: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(179),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 4.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Try to navigate back to dashboard
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.dashboard,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellow,
                        padding: EdgeInsets.symmetric(vertical: 3.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Return to Dashboard',
                        style: GoogleFonts.poppins(
                          color: AppTheme.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 3.h),

              // Debug Info (only in debug mode)
              if (kDebugMode) ...[
                ExpansionTile(
                  title: Text(
                    'Debug Information',
                    style: GoogleFonts.poppins(
                      color: AppTheme.white.withAlpha(179),
                      fontSize: 14,
                    ),
                  ),
                  iconColor: AppTheme.white.withAlpha(179),
                  collapsedIconColor: AppTheme.white.withAlpha(179),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        errorDetails.toString(),
                        style: GoogleFonts.robotoMono(
                          color: AppTheme.white.withAlpha(179),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}