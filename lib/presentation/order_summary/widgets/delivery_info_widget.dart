import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DeliveryInfoWidget extends StatefulWidget {
  final DateTime? orderPlacedTime;

  const DeliveryInfoWidget({
    super.key,
    this.orderPlacedTime,
  });

  @override
  State<DeliveryInfoWidget> createState() => _DeliveryInfoWidgetState();
}

class _DeliveryInfoWidgetState extends State<DeliveryInfoWidget> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream =
        Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  String _formatCountdown(DateTime orderTime) {
    final now = DateTime.now();
    final deliveryTime = orderTime.add(const Duration(hours: 16));
    final difference = deliveryTime.difference(now);

    if (difference.isNegative) {
      return 'Delivery overdue';
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_shipping',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Delivery Guarantee',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '12-16 Hour Turnaround',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onTertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your professionally edited photos will be delivered within 16 hours of order placement.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onTertiary
                  .withValues(alpha: 0.9),
            ),
          ),
          widget.orderPlacedTime != null
              ? Column(
                  children: [
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.onTertiary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Time Remaining',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onTertiary
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          StreamBuilder<DateTime>(
                            stream: _timeStream,
                            builder: (context, snapshot) {
                              return Text(
                                _formatCountdown(widget.orderPlacedTime!),
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onTertiary,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: [
                                    const FontFeature.tabularFigures()
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
