// widgets/spotlight_painter.dart
import 'package:flutter/material.dart';

class SpotlightPainter extends CustomPainter {
  final Rect? spotlightRect;
  final double animationValue;

  SpotlightPainter({
    this.spotlightRect,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (spotlightRect == null) {
      // No spotlight, just dark overlay
      final paint = Paint()..color = Colors.black.withOpacity(0.8);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      return;
    }

    // Create the main overlay paint
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.85)
      ..style = PaintingStyle.fill;

    // Create the background path (entire screen)
    Path background = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Create the hole (spotlight area) with more padding
    final spotlightPadding = 16.0;
    final enlargedSpotlight = Rect.fromLTRB(
      spotlightRect!.left - spotlightPadding,
      spotlightRect!.top - spotlightPadding,
      spotlightRect!.right + spotlightPadding,
      spotlightRect!.bottom + spotlightPadding,
    );
    
    Path hole = Path()..addRRect(
      RRect.fromRectAndRadius(enlargedSpotlight, Radius.circular(16))
    );

    // Combine paths to create overlay with transparent hole
    Path combined = Path.combine(PathOperation.difference, background, hole);
    canvas.drawPath(combined, overlayPaint);

    // Add animated glow effect around the spotlight
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3 * animationValue)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawRRect(
      RRect.fromRectAndRadius(enlargedSpotlight, Radius.circular(16)),
      glowPaint,
    );

    // Add subtle pulsing ring
    final ringPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.4 * animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        enlargedSpotlight.inflate(4 * animationValue),
        Radius.circular(20),
      ),
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
