import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SideControlsWidget extends StatelessWidget {
  final double zoomLevel;
  final ValueChanged<double> onZoomChanged;
  final String aspectRatio;
  final ValueChanged<String> onAspectRatioChanged;
  final VoidCallback onInfoTap;

  const SideControlsWidget({
    super.key,
    required this.zoomLevel,
    required this.onZoomChanged,
    required this.aspectRatio,
    required this.onAspectRatioChanged,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 2.w,
      top: 20.h,
      bottom: 20.h,
      child: Container(
        width: 12.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Info button
            _buildControlButton(
              icon: 'info_outline',
              onTap: onInfoTap,
            ),

            // Zoom controls
            _buildZoomControls(),

            // Aspect ratio selector
            _buildAspectRatioSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      height: 30.h,
      child: Column(
        children: [
          // Zoom level indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${zoomLevel.toStringAsFixed(1)}x',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Zoom slider
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: Builder(
                builder: (context) => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: 18,
                    ),
                    activeTrackColor: AppTheme.accentStart,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
                    thumbColor: AppTheme.accentStart,
                    overlayColor: AppTheme.accentStart.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: zoomLevel,
                    min: 1.0,
                    max: 10.0,
                    divisions: 90,
                    onChanged: onZoomChanged,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAspectRatioSelector() {
    final ratios = ['4:3', '16:9', '1:1'];

    return Container(
      child: Column(
        children: ratios.map((ratio) {
          final isSelected = aspectRatio == ratio;
          return GestureDetector(
            onTap: () => onAspectRatioChanged(ratio),
            child: Container(
              margin: EdgeInsets.only(bottom: 1.h),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.accentStart.withValues(alpha: 0.8)
                    : Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.accentStart
                      : Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                ratio,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
