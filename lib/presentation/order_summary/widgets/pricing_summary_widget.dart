import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PricingSummaryWidget extends StatelessWidget {
  final double subtotal;
  final double taxAmount;
  final double total;
  final String? promoCode;
  final double? discountAmount;

  const PricingSummaryWidget({
    super.key,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    this.promoCode,
    this.discountAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pricing Summary',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', false),
          SizedBox(height: 1.h),
          discountAmount != null && discountAmount! > 0
              ? Column(
                  children: [
                    _buildPriceRow(
                      'Discount ($promoCode)',
                      '-\$${discountAmount!.toStringAsFixed(2)}',
                      false,
                      isDiscount: true,
                    ),
                    SizedBox(height: 1.h),
                  ],
                )
              : const SizedBox.shrink(),
          _buildPriceRow('Tax', '\$${taxAmount.toStringAsFixed(2)}', false),
          SizedBox(height: 2.h),
          Container(
            height: 1,
            width: double.infinity,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          SizedBox(height: 2.h),
          _buildPriceRow('Total', '\$${total.toStringAsFixed(2)}', true),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.successColor,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'All prices include our satisfaction guarantee. If you\'re not happy, we\'ll re-edit for free.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, bool isTotal,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: isDiscount
                      ? AppTheme.successColor
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
        ),
        Text(
          amount,
          style: isTotal
              ? AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentStart,
                )
              : AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDiscount
                      ? AppTheme.successColor
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }
}
