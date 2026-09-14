import 'package:flutter/material.dart';

/// Crisp Neobrutalism Google 'G' Icon Painter (Custom, no external asset dependency)
class GoogleLogoPainter extends CustomPainter {
  const GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double strokeWidth = width * 0.22;
    final center = Offset(width / 2, height / 2);
    final radius = (width - strokeWidth) / 2;

    final paintBlue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Blue arc (top-right to right)
    canvas.drawArc(rect, -0.785, 1.57, false, paintBlue);

    // Green arc (bottom-right to bottom-left)
    canvas.drawArc(rect, 0.785, 1.57, false, paintGreen);

    // Yellow arc (bottom-left to top-left)
    canvas.drawArc(rect, 2.356, 1.57, false, paintYellow);

    // Red arc (top-left to top-right)
    canvas.drawArc(rect, 3.927, 1.57, false, paintRed);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final barRect = Rect.fromLTWH(
      center.dx,
      center.dy - strokeWidth / 2,
      radius + strokeWidth / 2,
      strokeWidth,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GoogleIcon extends StatelessWidget {
  final double size;

  const GoogleIcon({super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: const GoogleLogoPainter(),
    );
  }
}
