import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An original stroke-based line icon for one of Lumen's eight modules,
/// drawn on a fixed 24 by 24 logical canvas, the same visual language
/// (and the same module-to-shape mapping) as the icon set already
/// shipped on lumen-website's phone mockup, ported here as real vector
/// drawing rather than a bundled image, so it recolors and scales
/// correctly under every theme and text scale.
class ModuleIcon extends StatelessWidget {
  const ModuleIcon({super.key, required this.moduleId, this.size = 24});

  final String moduleId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color =
        IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
          painter: _ModuleIconPainter(moduleId: moduleId, color: color)),
    );
  }
}

class _ModuleIconPainter extends CustomPainter {
  _ModuleIconPainter({required this.moduleId, required this.color});

  final String moduleId;
  final Color color;

  static const double _strokeWidth = 1.6;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (moduleId) {
      case 'vision':
        canvas.drawOval(
            Rect.fromCenter(
                center: const Offset(12, 12), width: 18, height: 11),
            stroke);
        canvas.drawCircle(const Offset(12, 12), 2.1, fill);
      case 'hearing':
        canvas.drawLine(const Offset(7, 15), const Offset(7, 9), stroke);
        canvas.drawLine(const Offset(12, 17), const Offset(12, 6), stroke);
        canvas.drawLine(const Offset(17, 15), const Offset(17, 10), stroke);
      case 'speech':
        final bubble = RRect.fromRectAndRadius(
          const Rect.fromLTWH(3.5, 5.5, 17, 11),
          const Radius.circular(4),
        );
        canvas.drawRRect(bubble, stroke);
        final tail = Path()
          ..moveTo(8, 16.5)
          ..lineTo(6, 20)
          ..lineTo(6, 16.2);
        canvas.drawPath(tail, stroke);
        for (final x in [9.0, 12.0, 15.0]) {
          canvas.drawCircle(Offset(x, 11), 0.9, fill);
        }
      case 'reading':
        final book = Path()
          ..moveTo(12, 7)
          ..lineTo(4, 5.8)
          ..lineTo(4, 17.8)
          ..lineTo(12, 19)
          ..lineTo(20, 17.8)
          ..lineTo(20, 5.8)
          ..close();
        canvas.drawPath(book, stroke);
        canvas.drawLine(const Offset(12, 7), const Offset(12, 19), stroke);
      case 'memory':
        canvas.drawCircle(const Offset(12, 12), 8.3, stroke);
        canvas.drawLine(const Offset(12, 12), const Offset(12, 7.4), stroke);
        canvas.drawLine(const Offset(12, 12), const Offset(15.1, 13.9), stroke);
      case 'mobility':
        _drawRotatedFootprint(
            canvas, stroke, const Offset(8.4, 9), 2.2, 3.1, -18);
        _drawRotatedFootprint(
            canvas, stroke, const Offset(15.7, 15.3), 2.2, 3.1, 14);
      case 'safety':
        final shield = Path()
          ..moveTo(12, 3.5)
          ..lineTo(18.5, 6)
          ..lineTo(18.5, 11)
          ..lineTo(12, 19.5)
          ..lineTo(5.5, 11)
          ..lineTo(5.5, 6)
          ..close();
        canvas.drawPath(shield, stroke);
      case 'family':
        canvas.drawCircle(const Offset(8.6, 8.5), 2.8, stroke);
        canvas.drawArc(
          Rect.fromCenter(
              center: const Offset(8.6, 19.3), width: 9.4, height: 9.4),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        canvas.drawCircle(const Offset(16.2, 9.4), 2.2, stroke);
        canvas.drawArc(
          Rect.fromCenter(
              center: const Offset(16.2, 19.3), width: 7.6, height: 7.6),
          math.pi,
          math.pi * 0.62,
          false,
          stroke,
        );
    }

    canvas.restore();
  }

  void _drawRotatedFootprint(
    Canvas canvas,
    Paint paint,
    Offset center,
    double rx,
    double ry,
    double degrees,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(degrees * math.pi / 180);
    canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2),
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ModuleIconPainter oldDelegate) =>
      oldDelegate.moduleId != moduleId || oldDelegate.color != color;
}
