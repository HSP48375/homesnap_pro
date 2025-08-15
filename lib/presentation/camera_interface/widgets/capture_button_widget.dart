import 'package:flutter/material.dart';

class CaptureButtonWidget extends StatelessWidget {
  final bool isCapturing;
  final bool isBurstMode;
  final VoidCallback onCapture;
  final VoidCallback onBurstCapture;

  const CaptureButtonWidget({
    super.key,
    required this.isCapturing,
    required this.isBurstMode,
    required this.onCapture,
    required this.onBurstCapture,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Burst Mode Button
        GestureDetector(
          onTap: isCapturing ? null : onBurstCapture,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isBurstMode ? Colors.orange : Colors.white.withAlpha(77),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(
              Icons.burst_mode,
              color: isBurstMode ? Colors.white : Colors.white,
              size: 24,
            ),
          ),
        ),

        // Main Capture Button
        GestureDetector(
          onTap: isCapturing ? null : onCapture,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isCapturing ? Colors.grey : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: isCapturing
                ? const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  )
                : const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 32,
                  ),
          ),
        ),

        // Gallery/Review Button
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(77),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.photo_library,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
