import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SpecialInstructionsWidget extends StatefulWidget {
  final String initialInstructions;
  final Function(String) onInstructionsChanged;

  const SpecialInstructionsWidget({
    super.key,
    required this.initialInstructions,
    required this.onInstructionsChanged,
  });

  @override
  State<SpecialInstructionsWidget> createState() =>
      _SpecialInstructionsWidgetState();
}

class _SpecialInstructionsWidgetState extends State<SpecialInstructionsWidget> {
  late TextEditingController _controller;
  static const int _maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialInstructions);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.onInstructionsChanged(_controller.text);
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
            'Special Instructions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Any specific editing requests or preferences?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 4,
              maxLength: _maxCharacters,
              decoration: InputDecoration(
                hintText:
                    'e.g., Please enhance natural lighting in the living room photos, remove personal items from bedroom shots...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(3.w),
                counterText: '',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.7),
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Be specific to get the best results',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${_controller.text.length}/$_maxCharacters',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _controller.text.length > _maxCharacters * 0.9
                      ? AppTheme.warningColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
