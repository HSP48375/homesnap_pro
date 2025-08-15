import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class SpecialInstructionsWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SpecialInstructionsWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SpecialInstructionsWidget> createState() =>
      _SpecialInstructionsWidgetState();
}

class _SpecialInstructionsWidgetState extends State<SpecialInstructionsWidget> {
  static const int maxCharacters = 500;
  int _characterCount = 0;

  @override
  void initState() {
    super.initState();
    _characterCount = widget.controller.text.length;
    widget.controller.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = widget.controller.text.length;
    });
  }

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
                Icons.note_alt_outlined,
                color: AppTheme.yellow,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Special Instructions',
                style: GoogleFonts.poppins(
                  color: AppTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          Text(
            'Any specific requests, focus areas, or notes for the photographer',
            style: GoogleFonts.poppins(
              color: AppTheme.white.withAlpha(179),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 3.h),

          // Text Area
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.white.withAlpha(51),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              maxLines: 5,
              maxLength: maxCharacters,
              onChanged: widget.onChanged,
              style: GoogleFonts.poppins(
                color: AppTheme.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText:
                    'e.g., Focus on natural lighting in living room, avoid personal items in bedrooms, capture unique architectural features...',
                hintStyle: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(128),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                counterText: '', // Hide default counter
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Character Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _characterCount > 0
                    ? 'Optional - helps ensure best results'
                    : '',
                style: GoogleFonts.poppins(
                  color: AppTheme.white.withAlpha(128),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$_characterCount/$maxCharacters',
                style: GoogleFonts.poppins(
                  color: _characterCount > maxCharacters * 0.9
                      ? AppTheme.yellow
                      : AppTheme.white.withAlpha(128),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Quick Suggestions
          Text(
            'Quick Suggestions',
            style: GoogleFonts.poppins(
              color: AppTheme.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 2.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: [
              _buildSuggestionChip('Focus on natural lighting'),
              _buildSuggestionChip('Capture unique features'),
              _buildSuggestionChip('Wide-angle shots preferred'),
              _buildSuggestionChip('Include outdoor spaces'),
              _buildSuggestionChip('Highlight recent renovations'),
              _buildSuggestionChip('Minimize personal items'),
            ],
          ),

          SizedBox(height: 3.h),

          // Professional Tips
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.white.withAlpha(13),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.white.withAlpha(51),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.camera_enhance,
                  color: AppTheme.yellow,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Tips',
                        style: GoogleFonts.poppins(
                          color: AppTheme.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Clear instructions help photographers deliver exactly what you need. Mention specific rooms, angles, or features that are important for your listing.',
                        style: GoogleFonts.poppins(
                          color: AppTheme.white.withAlpha(179),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () => _addSuggestion(text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.white.withAlpha(26),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.white.withAlpha(51),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: AppTheme.white,
              size: 3.w,
            ),
            SizedBox(width: 1.w),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: AppTheme.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSuggestion(String suggestion) {
    String currentText = widget.controller.text;
    String newText;

    if (currentText.isEmpty) {
      newText = suggestion;
    } else if (currentText.endsWith('.') || currentText.endsWith(',')) {
      newText = '$currentText $suggestion';
    } else {
      newText = '$currentText. $suggestion';
    }

    if (newText.length <= maxCharacters) {
      widget.controller.text = newText;
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
      widget.onChanged(newText);
    }
  }
}
