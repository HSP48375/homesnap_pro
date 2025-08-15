import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final String aspectRatio;
  final VoidCallback? onTap;

  const CameraPreviewWidget({
    super.key,
    required this.cameraController,
    required this.aspectRatio,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.accentStart,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing Camera...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTapUp: (details) {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: _buildAspectRatioPreview(),
      ),
    );
  }

  Widget _buildAspectRatioPreview() {
    double aspectRatioValue;

    switch (aspectRatio) {
      case '16:9':
        aspectRatioValue = 16 / 9;
        break;
      case '1:1':
        aspectRatioValue = 1.0;
        break;
      case '4:3':
      default:
        aspectRatioValue = 4 / 3;
        break;
    }

    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatioValue,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: CameraPreview(cameraController!),
        ),
      ),
    );
  }
}
