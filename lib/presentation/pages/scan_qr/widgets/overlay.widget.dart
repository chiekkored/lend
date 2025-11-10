import 'package:flutter/material.dart';

class QRCodeOverlayW extends StatelessWidget {
  final double squareSize;
  final double borderWidth;
  final Color overlayColor;
  final Color borderColor;
  final double borderRadius;

  const QRCodeOverlayW({
    super.key,
    required this.squareSize,
    this.borderWidth = 2.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.5),
    this.borderColor = Colors.white,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final left = (width - squareSize) / 2;
        final top = (height - squareSize) / 2;

        return CustomPaint(
          size: Size(width, height),
          painter: _OverlayPainter(
            overlayColor: overlayColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            borderRadius: borderRadius,
            squareRect: Rect.fromLTWH(left, top, squareSize, squareSize),
          ),
        );
      },
    );
  }
}

class _OverlayPainter extends CustomPainter {
  final Color overlayColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Rect squareRect;

  _OverlayPainter({
    required this.overlayColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.squareRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = overlayColor
          ..style = PaintingStyle.fill;

    // Draw the dimmed overlay
    final overlayPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Cut out the transparent area (hole)
    final holePath =
        Path()..addRRect(
          RRect.fromRectAndRadius(squareRect, Radius.circular(borderRadius)),
        );

    final combined = Path.combine(
      PathOperation.difference,
      overlayPath,
      holePath,
    );
    canvas.drawPath(combined, paint);

    // Draw the border around the hole
    final borderPaint =
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth;
    canvas.drawRRect(
      RRect.fromRectAndRadius(squareRect, Radius.circular(borderRadius)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
