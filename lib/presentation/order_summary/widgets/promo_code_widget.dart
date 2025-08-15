import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PromoCodeWidget extends StatefulWidget {
  final String? appliedPromoCode;
  final Function(String) onPromoCodeApplied;
  final VoidCallback? onPromoCodeRemoved;

  const PromoCodeWidget({
    super.key,
    this.appliedPromoCode,
    required this.onPromoCodeApplied,
    this.onPromoCodeRemoved,
  });

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  late TextEditingController _controller;
  bool _isValidating = false;
  String? _errorMessage;

  final List<String> _validPromoCodes = [
    'FIRST20',
    'SAVE15',
    'NEWUSER',
    'WELCOME10',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.appliedPromoCode ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyPromoCode() async {
    final code = _controller.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a promo code';
      });
      return;
    }

    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    // Simulate API validation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isValidating = false;
    });

    if (_validPromoCodes.contains(code)) {
      widget.onPromoCodeApplied(code);
      setState(() {
        _errorMessage = null;
      });
    } else {
      setState(() {
        _errorMessage = 'Invalid promo code. Please try again.';
      });
    }
  }

  void _removePromoCode() {
    _controller.clear();
    widget.onPromoCodeRemoved?.call();
    setState(() {
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAppliedCode =
        widget.appliedPromoCode != null && widget.appliedPromoCode!.isNotEmpty;

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
            'Promo Code',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          hasAppliedCode
              ? Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.successColor,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.successColor,
                        size: 5.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Code Applied: ${widget.appliedPromoCode}',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'You\'re saving money on this order!',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _removePromoCode,
                        child: Text(
                          'Remove',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _errorMessage != null
                                    ? AppTheme.errorColor
                                    : AppTheme.lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.3),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Enter promo code',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(3.w),
                                hintStyle: AppTheme
                                    .lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        ElevatedButton(
                          onPressed: _isValidating ? null : _applyPromoCode,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.w),
                          ),
                          child: _isValidating
                              ? SizedBox(
                                  width: 4.w,
                                  height: 4.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme
                                          .lightTheme.colorScheme.onTertiary,
                                    ),
                                  ),
                                )
                              : Text('Apply'),
                        ),
                      ],
                    ),
                    _errorMessage != null
                        ? Column(
                            children: [
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'error',
                                    color: AppTheme.errorColor,
                                    size: 4.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.errorColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 2.h),
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
                            iconName: 'local_offer',
                            color: AppTheme.accentStart,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Try: FIRST20, SAVE15, NEWUSER, or WELCOME10',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
