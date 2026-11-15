import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// İstatistik grupları arasındaki "aynı karede Messi & Ronaldo" görseli.
/// assets/images/vs_1.jpg, vs_2.jpg ... dosyalarını koyarsan onları gösterir;
/// dosya yoksa çizimle üretilmiş 10 vs 7 kartı görünür.
class VsBanner extends StatelessWidget {
  final int index;
  final String caption;
  final bool national; // true: Arjantin 10 vs Portekiz 7 formaları
  const VsBanner({super.key, required this.index, required this.caption, this.national = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset(
              national ? 'assets/images/vs_milli_$index.jpg' : 'assets/images/vs_$index.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => CustomPaint(painter: _VsPainter(national: national)),
            ),
            // alt gradyan + açıklama
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xDD000000)],
                  stops: [0.55, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Text(caption, style: AppText.body(12.5, color: AppColors.white, weight: FontWeight.w600)),
            ),
          ]),
        ),
      ),
    );
  }
}

class _VsPainter extends CustomPainter {
  final bool national;
  const _VsPainter({this.national = false});

  static const _sky = Color(0xFF75AADB);
  static const _portRed = Color(0xFFC8102E);
  static const _portGreen = Color(0xFF046A38);
  static const _portGold = Color(0xFFE9C46A);

  // Kulüp renklerinden esinlenen çizim formalar (logo yok)
  static const _blue = Color(0xFF0B3F8F);
  static const _garnet = Color(0xFF9B0E3E);
  static const _barcaGold = Color(0xFFF2C230);
  static const _navy = Color(0xFF1B2A55);
  static const _rmGold = Color(0xFFC9A44C);

  @override
  void paint(Canvas canvas, Size s) {
    // Arka plan: sol bordo-lacivert, sağ koyu lacivert-gri; çapraz bölünmüş
    final left = Path()
      ..moveTo(0, 0)
      ..lineTo(s.width * 0.58, 0)
      ..lineTo(s.width * 0.42, s.height)
      ..lineTo(0, s.height)
      ..close();
    final right = Path()
      ..moveTo(s.width * 0.58, 0)
      ..lineTo(s.width, 0)
      ..lineTo(s.width, s.height)
      ..lineTo(s.width * 0.42, s.height)
      ..close();
    canvas.drawPath(
        left,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: national
                ? const [Color(0xFF0E2A47), Color(0xFF3E6E99)]
                : const [Color(0xFF0A1C44), Color(0xFF3B0820)],
          ).createShader(Offset.zero & s));
    canvas.drawPath(
        right,
        Paint()
          ..shader = LinearGradient(
                  colors: national
                      ? const [Color(0xFF4A0A14), Color(0xFF0F2A1C)]
                      : const [Color(0xFF26283A), Color(0xFF0F1018)])
              .createShader(Offset.zero & s));

    final hatch = Paint()
      ..color = fade(Colors.white, 0.035)
      ..strokeWidth = 1;
    for (double x = -s.height; x < s.width; x += 10) {
      canvas.drawLine(Offset(x, s.height), Offset(x + s.height, 0), hatch);
    }

    final h = s.height * 0.64;
    if (national) {
      _nationalJersey(canvas, Offset(s.width * 0.23, s.height * 0.47), h, argentina: true);
      _nationalJersey(canvas, Offset(s.width * 0.77, s.height * 0.47), h, argentina: false);
    } else {
      _jersey(canvas, Offset(s.width * 0.23, s.height * 0.47), h, barca: true);
      _jersey(canvas, Offset(s.width * 0.77, s.height * 0.47), h, barca: false);
    }

    // VS rozeti
    final center = Offset(s.width / 2, s.height * 0.47);
    final r = s.height * 0.16;
    canvas.drawCircle(center, r + 4, Paint()..color = fade(AppColors.gold, 0.25));
    canvas.drawCircle(center, r, Paint()..color = AppColors.black);
    canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);
    final vs = TextPainter(
      text: TextSpan(text: 'VS', style: AppText.display(r * 1.05, color: AppColors.gold)),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 32);
    vs.paint(canvas, Offset(-vs.width / 2, -vs.height / 2));
    canvas.restore();
  }

  Path _bodyPath(Offset c, double h) {
    final w = h * 0.95;
    return Path()
      ..moveTo(c.dx - w * 0.22, c.dy - h * 0.5)
      ..lineTo(c.dx - w * 0.5, c.dy - h * 0.36)
      ..lineTo(c.dx - w * 0.42, c.dy - h * 0.12)
      ..lineTo(c.dx - w * 0.3, c.dy - h * 0.16)
      ..lineTo(c.dx - w * 0.3, c.dy + h * 0.5)
      ..lineTo(c.dx + w * 0.3, c.dy + h * 0.5)
      ..lineTo(c.dx + w * 0.3, c.dy - h * 0.16)
      ..lineTo(c.dx + w * 0.42, c.dy - h * 0.12)
      ..lineTo(c.dx + w * 0.5, c.dy - h * 0.36)
      ..lineTo(c.dx + w * 0.22, c.dy - h * 0.5)
      ..quadraticBezierTo(c.dx, c.dy - h * 0.34, c.dx - w * 0.22, c.dy - h * 0.5)
      ..close();
  }

  void _nationalJersey(Canvas canvas, Offset c, double h, {required bool argentina}) {
    final w = h * 0.95;
    final body = _bodyPath(c, h);
    canvas.drawShadow(body, Colors.black, 10, false);
    canvas.save();
    canvas.clipPath(body);
    final bounds = Rect.fromCenter(center: c, width: w, height: h);
    if (argentina) {
      // beyaz zemin + dikey açık mavi çubuklar
      canvas.drawRect(bounds, Paint()..color = Colors.white);
      const n = 7;
      final sw = bounds.width / n;
      for (var i = 1; i < n; i += 2) {
        canvas.drawRect(Rect.fromLTWH(bounds.left + i * sw, bounds.top, sw, bounds.height), Paint()..color = _sky);
      }
    } else {
      // kırmızı gövde, yeşil kol bandı
      canvas.drawRect(
          bounds,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_portRed, Color(0xFF9E0B24)],
            ).createShader(bounds));
      for (final sign in [-1.0, 1.0]) {
        canvas.drawPath(
            Path()
              ..moveTo(c.dx + sign * w * 0.43, c.dy - h * 0.15)
              ..lineTo(c.dx + sign * w * 0.5, c.dy - h * 0.36)
              ..lineTo(c.dx + sign * w * 0.44, c.dy - h * 0.39)
              ..lineTo(c.dx + sign * w * 0.37, c.dy - h * 0.17)
              ..close(),
            Paint()..color = _portGreen);
      }
    }
    canvas.restore();

    final collar = Path()
      ..moveTo(c.dx - w * 0.22, c.dy - h * 0.5)
      ..quadraticBezierTo(c.dx, c.dy - h * 0.30, c.dx + w * 0.22, c.dy - h * 0.5);
    canvas.drawPath(
        collar,
        Paint()
          ..color = argentina ? const Color(0xFF1B2A55) : _portGreen
          ..style = PaintingStyle.stroke
          ..strokeWidth = h * 0.045
          ..strokeCap = StrokeCap.round);
    canvas.drawPath(
        body,
        Paint()
          ..color = fade(Colors.black, 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    final tp = TextPainter(
      text: TextSpan(
        text: argentina ? '10' : '7',
        style: AppText.display(h * 0.5, color: argentina ? const Color(0xFF111827) : _portGold).copyWith(
          shadows: [Shadow(color: argentina ? Colors.white : Colors.black54, offset: const Offset(1.5, 1.5))],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2 + h * 0.07));
  }

  void _jersey(Canvas canvas, Offset c, double h, {required bool barca}) {
    final w = h * 0.95;
    final body = _bodyPath(c, h);
    canvas.drawShadow(body, Colors.black, 10, false);

    canvas.save();
    canvas.clipPath(body);
    final bounds = Rect.fromCenter(center: c, width: w, height: h);
    if (barca) {
      // dikey mavi–bordo şeritler
      const n = 7;
      final sw = bounds.width / n;
      for (var i = 0; i < n; i++) {
        canvas.drawRect(Rect.fromLTWH(bounds.left + i * sw, bounds.top, sw + 0.5, bounds.height),
            Paint()..color = i.isEven ? _garnet : _blue);
      }
    } else {
      // beyaz gövde, hafif gölgeli
      canvas.drawRect(
          bounds,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFE4E6EE)],
            ).createShader(bounds));
      // kol bandı: lacivert
      canvas.drawPath(
          Path()
            ..moveTo(c.dx - w * 0.43, c.dy - h * 0.15)
            ..lineTo(c.dx - w * 0.5, c.dy - h * 0.36)
            ..lineTo(c.dx - w * 0.44, c.dy - h * 0.39)
            ..lineTo(c.dx - w * 0.37, c.dy - h * 0.17)
            ..close(),
          Paint()..color = _navy);
      canvas.drawPath(
          Path()
            ..moveTo(c.dx + w * 0.43, c.dy - h * 0.15)
            ..lineTo(c.dx + w * 0.5, c.dy - h * 0.36)
            ..lineTo(c.dx + w * 0.44, c.dy - h * 0.39)
            ..lineTo(c.dx + w * 0.37, c.dy - h * 0.17)
            ..close(),
          Paint()..color = _navy);
      // yan şerit
      canvas.drawRect(Rect.fromLTWH(c.dx - w * 0.3, c.dy - h * 0.16, w * 0.025, h * 0.66), Paint()..color = _navy);
      canvas.drawRect(Rect.fromLTWH(c.dx + w * 0.275, c.dy - h * 0.16, w * 0.025, h * 0.66), Paint()..color = _navy);
    }
    canvas.restore();

    // yaka
    final collar = Path()
      ..moveTo(c.dx - w * 0.22, c.dy - h * 0.5)
      ..quadraticBezierTo(c.dx, c.dy - h * 0.30, c.dx + w * 0.22, c.dy - h * 0.5);
    canvas.drawPath(
        collar,
        Paint()
          ..color = barca ? _barcaGold : _navy
          ..style = PaintingStyle.stroke
          ..strokeWidth = h * 0.045
          ..strokeCap = StrokeCap.round);
    if (!barca) {
      canvas.drawPath(
          collar.shift(Offset(0, h * 0.03)),
          Paint()
            ..color = _rmGold
            ..style = PaintingStyle.stroke
            ..strokeWidth = h * 0.012);
    }
    canvas.drawPath(
        body,
        Paint()
          ..color = fade(Colors.black, 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

    // numara
    final tp = TextPainter(
      text: TextSpan(
        text: barca ? '10' : '7',
        style: AppText.display(h * 0.5, color: barca ? _barcaGold : _navy).copyWith(
          shadows: [Shadow(color: barca ? Colors.black54 : _rmGold, offset: const Offset(1.5, 1.5))],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2 + h * 0.07));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
