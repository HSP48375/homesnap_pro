import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class BiometricPromptWidget extends StatelessWidget {
  final String biometricType;
  final VoidCallback? onEnableBiometric;
  final VoidCallback? onSkipBiometric;

  const BiometricPromptWidget({
    Key? key,
    required this.biometricType,
    this.onEnableBiometric,
    this.onSkipBiometric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(
            biometricType == 'face' ? Icons.face : Icons.fingerprint,
            color: AppTheme.yellow,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Enable Face ID',
              style: GoogleFonts.inter(
                color: Colors.white.withAlpha(204),
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GestureDetector(
            onTap: onEnableBiometric,
            child: Text(
              'Enable',
              style: GoogleFonts.inter(
                color: AppTheme.yellow,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
