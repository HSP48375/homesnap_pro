import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class PropertyDetailsWidget extends StatelessWidget {
  final TextEditingController squareFootageController;
  final TextEditingController bedroomsController;
  final TextEditingController bathroomsController;
  final Function({int? squareFootage, int? bedrooms, int? bathrooms})
      onDetailsChanged;

  const PropertyDetailsWidget({
    Key? key,
    required this.squareFootageController,
    required this.bedroomsController,
    required this.bathroomsController,
    required this.onDetailsChanged,
  }) : super(key: key);

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
                Icons.home_work_outlined,
                color: AppTheme.yellow,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Property Details',
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
            'Optional details help estimate photo count and pricing',
            style: GoogleFonts.poppins(
              color: AppTheme.white.withAlpha(179),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 3.h),

          // Square Footage
          _buildInputField(
            controller: squareFootageController,
            label: 'Square Footage',
            hint: 'e.g., 2500',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final int? sqft = int.tryParse(value);
              if (sqft != null) {
                onDetailsChanged(squareFootage: sqft);
              }
            },
          ),

          SizedBox(height: 3.h),

          // Bedrooms and Bathrooms Row
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  controller: bedroomsController,
                  label: 'Bedrooms',
                  hint: '3',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final int? bedrooms = int.tryParse(value);
                    if (bedrooms != null) {
                      onDetailsChanged(bedrooms: bedrooms);
                    }
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildInputField(
                  controller: bathroomsController,
                  label: 'Bathrooms',
                  hint: '2.5',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    final double? bathrooms = double.tryParse(value);
                    if (bathrooms != null) {
                      onDetailsChanged(bathrooms: bathrooms.round());
                    }
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Quick Select Buttons
          Text(
            'Quick Select',
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
              _buildQuickSelectChip('Studio', () => _setQuickValues(500, 0, 1)),
              _buildQuickSelectChip(
                  '1BR/1BA', () => _setQuickValues(800, 1, 1)),
              _buildQuickSelectChip(
                  '2BR/2BA', () => _setQuickValues(1200, 2, 2)),
              _buildQuickSelectChip(
                  '3BR/2BA', () => _setQuickValues(1600, 3, 2)),
              _buildQuickSelectChip(
                  '4BR/3BA', () => _setQuickValues(2200, 4, 3)),
              _buildQuickSelectChip(
                  '5BR/4BA', () => _setQuickValues(3000, 5, 4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppTheme.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
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
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: GoogleFonts.poppins(
              color: AppTheme.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: AppTheme.white.withAlpha(128),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickSelectChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: AppTheme.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _setQuickValues(int sqft, int bedrooms, int bathrooms) {
    squareFootageController.text = sqft.toString();
    bedroomsController.text = bedrooms.toString();
    bathroomsController.text = bathrooms.toString();

    onDetailsChanged(
      squareFootage: sqft,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
    );
  }
}
