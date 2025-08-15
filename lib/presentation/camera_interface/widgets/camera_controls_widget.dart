import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraControlsWidget extends StatelessWidget {
  final bool isFlashOn;
  final bool isGridOn;
  final bool isBurstMode;
  final VoidCallback onFlashToggle;
  final VoidCallback onGridToggle;
  final VoidCallback onBurstToggle;
  final VoidCallback onCameraFlip;

  const CameraControlsWidget({
    super.key,
    required this.isFlashOn,
    required this.isGridOn,
    required this.isBurstMode,
    required this.onFlashToggle,
    required this.onGridToggle,
    required this.onBurstToggle,
    required this.onCameraFlip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildControlButton(
              icon: isFlashOn ? 'flash_on' : 'flash_off',
              label: 'Flash',
              isActive: isFlashOn,
              onTap: onFlashToggle,
            ),
            _buildControlButton(
              icon: 'grid_on',
              label: 'Grid',
              isActive: isGridOn,
              onTap: onGridToggle,
            ),
            _buildBurstModeButton(),
            _buildControlButton(
              icon: 'flip_camera_ios',
              label: 'Flip',
              isActive: false,
              onTap: onCameraFlip,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.accentStart.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: AppTheme.accentStart, width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isActive ? AppTheme.accentStart : Colors.white,
              size: 20,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isActive ? AppTheme.accentStart : Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBurstModeButton() {
    return GestureDetector(
      onTap: onBurstToggle,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isBurstMode
              ? AppTheme.accentStart.withValues(alpha: 0.2)
              : Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: isBurstMode
              ? Border.all(color: AppTheme.accentStart, width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CustomIconWidget(
                  iconName: 'camera_alt',
                  color: isBurstMode ? AppTheme.accentStart : Colors.white,
                  size: 20,
                ),
                if (isBurstMode)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.accentStart,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'ON',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Burst',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isBurstMode ? AppTheme.accentStart : Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
