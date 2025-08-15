import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatefulWidget {
  final String? selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;
  final VoidCallback? onAddNewCard;

  const PaymentMethodWidget({
    super.key,
    this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
    this.onAddNewCard,
  });

  @override
  State<PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState extends State<PaymentMethodWidget> {
  late String? _selectedMethod;

  final List<Map<String, dynamic>> _savedCards = [
    {
      'id': 'card_1',
      'type': 'visa',
      'lastFour': '4242',
      'expiryMonth': '12',
      'expiryYear': '25',
      'isDefault': true,
    },
    {
      'id': 'card_2',
      'type': 'mastercard',
      'lastFour': '8888',
      'expiryMonth': '08',
      'expiryYear': '26',
      'isDefault': false,
    },
  ];

  final List<Map<String, dynamic>> _digitalWallets = [
    {
      'id': 'apple_pay',
      'name': 'Apple Pay',
      'icon': 'apple',
      'available': true,
    },
    {
      'id': 'google_pay',
      'name': 'Google Pay',
      'icon': 'google',
      'available': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.selectedPaymentMethod ?? _savedCards.first['id'];
  }

  void _selectPaymentMethod(String methodId) {
    setState(() {
      _selectedMethod = methodId;
    });
    widget.onPaymentMethodChanged(methodId);
  }

  String _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'credit_card';
      case 'mastercard':
        return 'credit_card';
      case 'amex':
        return 'credit_card';
      default:
        return 'credit_card';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
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
          Text(
            'Payment Method',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Saved Cards Section
          Text(
            'Saved Cards',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _savedCards.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final card = _savedCards[index];
              final isSelected = _selectedMethod == card['id'];

              return GestureDetector(
                onTap: () => _selectPaymentMethod(card['id'] as String),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentStart.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentStart
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: _getCardIcon(card['type'] as String),
                        color: isSelected
                            ? AppTheme.accentStart
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '•••• •••• •••• ${card['lastFour']}',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                card['isDefault'] as bool
                                    ? Container(
                                        margin: EdgeInsets.only(left: 2.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w, vertical: 0.5.h),
                                        decoration: BoxDecoration(
                                          color: AppTheme.successColor
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: AppTheme.successColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                            Text(
                              'Expires ${card['expiryMonth']}/${card['expiryYear']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.accentStart
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentStart
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onTertiary,
                                size: 3.w,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),

          // Digital Wallets Section
          Text(
            'Digital Wallets',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _digitalWallets.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final wallet = _digitalWallets[index];
              final isSelected = _selectedMethod == wallet['id'];
              final isAvailable = wallet['available'] as bool;

              return GestureDetector(
                onTap: isAvailable
                    ? () => _selectPaymentMethod(wallet['id'] as String)
                    : null,
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentStart.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentStart
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'account_balance_wallet',
                        color: isSelected
                            ? AppTheme.accentStart
                            : isAvailable
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          wallet['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isAvailable
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.accentStart
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentStart
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onTertiary,
                                size: 3.w,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),

          // Add New Card Button
          OutlinedButton(
            onPressed: widget.onAddNewCard,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 6.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text('Add New Card'),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Security Notice
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.successColor,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Your payment information is encrypted and secure. We never store your full card details.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
}
