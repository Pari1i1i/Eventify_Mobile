import 'package:flutter/material.dart';

/// Function helper untuk membangun Banner Widget berdasarkan tipe event
Widget buildEventBannerWidget(Map<String, dynamic> event) {
  final bannerType = event['bannerType'] ?? '';

  if (bannerType == 'fun_run') {
    return CustomPaint(
      painter: FunRunBannerPainter(),
      child: Container(),
    );
  } else if (bannerType == 'pushbike') {
    return CustomPaint(
      painter: PushbikeBannerPainter(),
      child: Container(),
    );
  } else if (bannerType == 'tech') {
    return CustomPaint(
      painter: TechExpoBannerPainter(),
      child: Container(),
    );
  } else {
    return CustomPaint(
      painter: GenericBannerPainter(
        title: event['judul'] ?? '',
        bgColor: event['warnaHeader'] ?? const Color(0xFF8E24AA),
      ),
      child: Container(),
    );
  }
}

/// PAINTER POSTER: 8FINITY CHARITY FUN RUN 2026
class FunRunBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background Red Gradient
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8B0000), Color(0xFFD32F2F), Color(0xFFC62828)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Diagonal Blue Sash / Banner Wave
    final bluePath = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(0, size.height * 0.95)
      ..close();

    final bluePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF2575FC)],
      ).createShader(rect);
    canvas.drawShadow(bluePath, Colors.black.withOpacity(0.4), 6, true);
    canvas.drawPath(bluePath, bluePaint);

    // Upper Top Left Badge: Infinity logo symbol
    final logoBgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.09, size.height * 0.22), 18, logoBgPaint);
    final logoBorderPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(Offset(size.width * 0.09, size.height * 0.22), 18, logoBorderPaint);

    // Infinity Text in logo
    final logoTp = TextPainter(
      text: const TextSpan(
        text: '∞',
        style: TextStyle(color: Color(0xFF1565C0), fontSize: 24, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    logoTp.paint(canvas, Offset(size.width * 0.09 - logoTp.width / 2, size.height * 0.22 - logoTp.height / 2));

    // MAIN TITLE TEXT: "8 FINITY"
    final t1 = TextPainter(
      text: const TextSpan(
        text: '8 FINITY',
        style: TextStyle(
          color: Color(0xFFFFEB3B),
          fontSize: 26,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          letterSpacing: 2,
          shadows: [Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    t1.paint(canvas, Offset(size.width * 0.28, size.height * 0.10));

    // SECONDARY TITLE TEXT: "CHARITY FUN RUN"
    final t2 = TextPainter(
      text: const TextSpan(
        text: 'CHARITY FUN RUN',
        style: TextStyle(
          color: Color(0xFFFFEB3B),
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          shadows: [
            Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 4),
            Shadow(color: Colors.black54, offset: Offset(-1, -1), blurRadius: 2),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    t2.paint(canvas, Offset(size.width * 0.06, size.height * 0.34));

    // SLOGAN TEXT: "Infinite Steps, Endless Love."
    final t3 = TextPainter(
      text: const TextSpan(
        text: 'Infinite Steps, Endless Love.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w600,
          shadows: [Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    t3.paint(canvas, Offset(size.width * 0.24, size.height * 0.60));

    // BOTTOM SPONSOR / PARTNER BADGES BAR
    final bottomBarPath = Path()
      ..moveTo(0, size.height * 0.82)
      ..lineTo(size.width, size.height * 0.82)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final bottomBarPaint = Paint()..color = const Color(0xFFD32F2F);
    canvas.drawPath(bottomBarPath, bottomBarPaint);

    // Yellow Partner Ribbons
    final ribbon1 = Path()
      ..moveTo(size.width * 0.03, size.height * 0.83)
      ..lineTo(size.width * 0.24, size.height * 0.83)
      ..lineTo(size.width * 0.21, size.height * 0.97)
      ..lineTo(size.width * 0.03, size.height * 0.97)
      ..close();
    final ribbonPaint = Paint()..color = const Color(0xFFFFC107);
    canvas.drawPath(ribbon1, ribbonPaint);

    final r1Text = TextPainter(
      text: const TextSpan(
        text: 'COMMUNITY\nPARTNER',
        style: TextStyle(color: Colors.black, fontSize: 7, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    r1Text.paint(canvas, Offset(size.width * 0.05, size.height * 0.85));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// PAINTER POSTER: PUSHBIKE COMPETITION
class PushbikeBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Yellow Top & Green Bottom Gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFDD835), Color(0xFFFFEB3B), Color(0xFF81C784)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Checkered Finish Line Border Top & Bottom
    final checkPaint1 = Paint()..color = Colors.black;
    final checkPaint2 = Paint()..color = Colors.white;
    double sqSize = 10.0;

    for (double x = 0; x < size.width; x += sqSize) {
      canvas.drawRect(Rect.fromLTWH(x, size.height - sqSize, sqSize, sqSize), ((x / sqSize).floor() % 2 == 0) ? checkPaint1 : checkPaint2);
      canvas.drawRect(Rect.fromLTWH(x, size.height - (sqSize * 2), sqSize, sqSize), ((x / sqSize).floor() % 2 == 1) ? checkPaint1 : checkPaint2);
    }

    // MAIN TITLE BADGE: "PUSHBIKE COMPETITION"
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(size.width * 0.48, size.height * 0.32), width: size.width * 0.72, height: 60),
      const Radius.circular(16),
    );
    final badgePaint = Paint()..color = const Color(0xFFD32F2F);
    final badgeBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(badgeRect, badgePaint);
    canvas.drawRRect(badgeRect, badgeBorder);

    final title1 = TextPainter(
      text: const TextSpan(
        text: 'PUSHBIKE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    title1.paint(canvas, Offset(size.width * 0.48 - title1.width / 2, size.height * 0.18));

    final title2 = TextPainter(
      text: const TextSpan(
        text: 'COMPETITION',
        style: TextStyle(
          color: Color(0xFFFFEB3B),
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    title2.paint(canvas, Offset(size.width * 0.48 - title2.width / 2, size.height * 0.36));

    // SUBTITLE BANNER: "RIDE • RACE • FUN"
    final subRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(size.width * 0.48, size.height * 0.58), width: size.width * 0.45, height: 18),
      const Radius.circular(8),
    );
    final subPaint = Paint()..color = const Color(0xFF0D47A1);
    canvas.drawRRect(subRect, subPaint);

    final subText = TextPainter(
      text: const TextSpan(
        text: 'RIDE • RACE • FUN',
        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    subText.paint(canvas, Offset(size.width * 0.48 - subText.width / 2, size.height * 0.54));

    // RIGHT SIDE DETAILS BOX (SUMENEP EVENT CARD)
    final rightBoxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.68, size.height * 0.52, size.width * 0.28, size.height * 0.38),
      const Radius.circular(6),
    );
    canvas.drawRRect(rightBoxRect, Paint()..color = const Color(0xFF0D47A1));

    final infoText = TextPainter(
      text: const TextSpan(
        text: 'MINGGU\n6 DESEMBER 2026\nSUMENEP',
        style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold, height: 1.2),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    infoText.paint(canvas, Offset(size.width * 0.70, size.height * 0.55));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// PAINTER POSTER: TECH & AI EXPO
class TechExpoBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0F172A), Color(0xFF1E1B4B), Color(0xFF0EA5E9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    // Glowing Circles
    final glowPaint = Paint()
      ..color = const Color(0xFF38BDF8).withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.3), 60, glowPaint);

    final title = TextPainter(
      text: const TextSpan(
        text: 'TECH & AI\nINNOVATORS EXPO 2026',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          height: 1.2,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    title.paint(canvas, Offset(size.width * 0.08, size.height * 0.30));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// PAINTER POSTER: GENERIC FALLBACK BANNER
class GenericBannerPainter extends CustomPainter {
  final String title;
  final Color bgColor;

  GenericBannerPainter({required this.title, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgPaint = Paint()
      ..shader = LinearGradient(
        colors: [bgColor, bgColor.withOpacity(0.7), const Color(0xFF1E293B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width * 0.85);

    titlePainter.paint(canvas, Offset(size.width * 0.08, size.height * 0.35));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// PAINTER UNTUK HEADER PATTERN BINTIK-BINTIK (DOT PATTERN)
class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final dotPaint = Paint()
      ..color = const Color(0xFF2B2630).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const double spacing = 12.0;
    const double radius = 1.2;

    for (double x = 6; x < size.width; x += spacing) {
      for (double y = 6; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
