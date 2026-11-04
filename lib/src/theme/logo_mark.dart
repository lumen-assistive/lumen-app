import 'package:flutter/material.dart';

/// Lumen's mark: an open circular arc, the same one used on
/// lumen-website and in every repository's banner, ported here as a
/// real vector drawing (the same `arcToPoint` geometry as the
/// website's SVG path) rather than a bundled image, so it recolors and
/// scales correctly under every theme.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, required this.size, this.color, this.strokeWidth});

  final double size;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ??
        IconTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoMarkPainter(
          color: resolvedColor,
          strokeWidth: strokeWidth ?? size * 0.125,
        ),
      ),
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  _LogoMarkPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 48, size.height / 48);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * (48 / size.width)
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(33.2, 10.9)
      ..arcToPoint(
        const Offset(14.8, 10.9),
        radius: const Radius.circular(16),
        largeArc: true,
        clockwise: true,
      );

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LogoMarkPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
