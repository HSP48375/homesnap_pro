import 'package:flutter/material.dart';

class GridOverlayWidget extends StatelessWidget {
  final bool isVisible;

  const GridOverlayWidget({
    super.key,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: CustomPaint(
        painter: GridPainter(),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw vertical lines (rule of thirds)
    final verticalLine1 = size.width / 3;
    final verticalLine2 = (size.width / 3) * 2;

    canvas.drawLine(
      Offset(verticalLine1, 0),
      Offset(verticalLine1, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(verticalLine2, 0),
      Offset(verticalLine2, size.height),
      paint,
    );

    // Draw horizontal lines (rule of thirds)
    final horizontalLine1 = size.height / 3;
    final horizontalLine2 = (size.height / 3) * 2;

    canvas.drawLine(
      Offset(0, horizontalLine1),
      Offset(size.width, horizontalLine1),
      paint,
    );

    canvas.drawLine(
      Offset(0, horizontalLine2),
      Offset(size.width, horizontalLine2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
