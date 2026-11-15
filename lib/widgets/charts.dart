import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Dış paket kullanmadan çizilen grafikler (CustomPainter).

// ---------------------------------------------------------------------------
// Ortak: yatay ızgara + sol eksen etiketleri
// ---------------------------------------------------------------------------
void _paintGrid(Canvas canvas, Rect plot, double maxY, double step) {
  final grid = Paint()
    ..color = AppColors.line
    ..strokeWidth = 1;
  for (double y = 0; y <= maxY + 0.001; y += step) {
    final dy = plot.bottom - (y / maxY) * plot.height;
    canvas.drawLine(Offset(plot.left, dy), Offset(plot.right, dy), grid);
    final tp = TextPainter(
      text: TextSpan(text: y.toInt().toString(), style: AppText.body(10, color: AppColors.grey)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(plot.left - tp.width - 6, dy - tp.height / 2));
  }
}

void _paintLabel(Canvas canvas, String text, Offset center, TextStyle style) {
  final tp = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr)..layout();
  tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy));
}

// ---------------------------------------------------------------------------
// Gruplu sütun grafiği (Messi vs Ronaldo, sezon sezon)
// ---------------------------------------------------------------------------
class SeasonBarChart extends StatefulWidget {
  final List<String> labels;
  final List<int> messi;
  final List<int> ronaldo;
  final double maxY;
  const SeasonBarChart({
    super.key,
    required this.labels,
    required this.messi,
    required this.ronaldo,
    this.maxY = 55,
  });

  @override
  State<SeasonBarChart> createState() => _SeasonBarChartState();
}

class _SeasonBarChartState extends State<SeasonBarChart> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 210,
        child: LayoutBuilder(builder: (context, box) {
          return GestureDetector(
            onTapDown: (d) {
              final plotLeft = 30.0;
              final cw = (box.maxWidth - plotLeft) / widget.labels.length;
              final i = ((d.localPosition.dx - plotLeft) / cw).floor();
              if (i >= 0 && i < widget.labels.length) setState(() => _selected = i);
            },
            child: CustomPaint(
              size: Size(box.maxWidth, 210),
              painter: _BarPainter(widget.labels, widget.messi, widget.ronaldo, widget.maxY, _selected),
            ),
          );
        }),
      ),
      const SizedBox(height: 8),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          _selected == null
              ? 'Bir sezona dokun → o sezonun golleri'
              : '${widget.labels[_selected!]}  ·  Messi ${widget.messi[_selected!]}  —  Ronaldo ${widget.ronaldo[_selected!]}',
          key: ValueKey(_selected),
          style: AppText.body(11.5,
              color: _selected == null ? AppColors.grey : AppColors.white, weight: FontWeight.w700),
        ),
      ),
    ]);
  }
}

class _BarPainter extends CustomPainter {
  final List<String> labels;
  final List<int> a, b;
  final double maxY;
  final int? selected;
  _BarPainter(this.labels, this.a, this.b, this.maxY, this.selected);

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(30, 6, size.width, size.height - 22);
    _paintGrid(canvas, plot, maxY, 10);
    final cw = plot.width / labels.length;
    final bw = math.min(9.0, cw * 0.3);
    for (var i = 0; i < labels.length; i++) {
      final cx = plot.left + cw * i + cw / 2;
      final dim = selected != null && selected != i;
      void bar(double left, int v, Color c) {
        final h = (v / maxY) * plot.height;
        final r = RRect.fromRectAndCorners(
          Rect.fromLTWH(left, plot.bottom - h, bw, h),
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        );
        canvas.drawRRect(r, Paint()..color = dim ? fade(c, 0.35) : c);
      }

      bar(cx - bw - 1, a[i], AppColors.gold);
      bar(cx + 1, b[i], AppColors.ronaldo);
      _paintLabel(canvas, labels[i], Offset(cx, plot.bottom + 6), AppText.body(9, color: AppColors.grey));
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) => old.selected != selected;
}

// ---------------------------------------------------------------------------
// Çizgi grafik (Messi LaLiga golleri)
// ---------------------------------------------------------------------------
class GoalsLineChart extends StatefulWidget {
  final List<String> labels; // '04', '05' ...
  final List<int> values;
  final double maxY;
  const GoalsLineChart({super.key, required this.labels, required this.values, this.maxY = 55});

  @override
  State<GoalsLineChart> createState() => _GoalsLineChartState();
}

class _GoalsLineChartState extends State<GoalsLineChart> with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();
  int? _selected;

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 200,
        child: LayoutBuilder(builder: (context, box) {
          return GestureDetector(
            onTapDown: (d) {
              final plotLeft = 30.0;
              final step = (box.maxWidth - plotLeft - 8) / (widget.values.length - 1);
              final i = ((d.localPosition.dx - plotLeft) / step).round();
              if (i >= 0 && i < widget.values.length) setState(() => _selected = i);
            },
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, _) => CustomPaint(
                size: Size(box.maxWidth, 200),
                painter: _LinePainter(widget.labels, widget.values, widget.maxY,
                    Curves.easeOutCubic.transform(_anim.value), _selected),
              ),
            ),
          );
        }),
      ),
      const SizedBox(height: 8),
      Text(
        _selected == null
            ? 'Bir noktaya dokun → o sezonun golü'
            : '20${widget.labels[_selected!]}/${(int.parse(widget.labels[_selected!]) + 1).toString().padLeft(2, '0')}  ·  ${widget.values[_selected!]} gol',
        style: AppText.body(11.5,
            color: _selected == null ? AppColors.grey : AppColors.gold, weight: FontWeight.w700),
      ),
    ]);
  }
}

class _LinePainter extends CustomPainter {
  final List<String> labels;
  final List<int> values;
  final double maxY;
  final double progress;
  final int? selected;
  _LinePainter(this.labels, this.values, this.maxY, this.progress, this.selected);

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTRB(30, 6, size.width - 8, size.height - 22);
    _paintGrid(canvas, plot, maxY, 10);
    final step = plot.width / (values.length - 1);
    final pts = [
      for (var i = 0; i < values.length; i++)
        Offset(plot.left + i * step, plot.bottom - (values[i] * progress / maxY) * plot.height),
    ];

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length; i++) {
      final p0 = pts[i - 1], p1 = pts[i];
      final mx = (p0.dx + p1.dx) / 2;
      path.cubicTo(mx, p0.dy, mx, p1.dy, p1.dx, p1.dy);
    }
    final area = Path.from(path)
      ..lineTo(pts.last.dx, plot.bottom)
      ..lineTo(pts.first.dx, plot.bottom)
      ..close();
    canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [fade(AppColors.gold, 0.35), fade(AppColors.gold, 0)],
          ).createShader(plot));
    canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round);

    for (var i = 0; i < pts.length; i++) {
      final peak = values[i] == values.reduce(math.max);
      final sel = selected == i;
      canvas.drawCircle(pts[i], sel ? 6 : (peak ? 5 : 2.5), Paint()..color = (peak || sel) ? AppColors.white : AppColors.gold);
      if (i.isEven) {
        _paintLabel(canvas, "'${labels[i]}", Offset(pts[i].dx, plot.bottom + 6), AppText.body(9.5, color: AppColors.grey));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) => old.progress != progress || old.selected != selected;
}

// ---------------------------------------------------------------------------
// Radar grafik
// ---------------------------------------------------------------------------
class RadarChart extends StatelessWidget {
  final List<String> axes;
  final List<double> a; // Messi (0–100)
  final List<double> b; // Ronaldo (0–100)
  const RadarChart({super.key, required this.axes, required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1100),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) => CustomPaint(
          size: const Size(double.infinity, 260),
          painter: _RadarPainter(axes, a, b, t),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final List<String> axes;
  final List<double> a, b;
  final double t;
  _RadarPainter(this.axes, this.a, this.b, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2 + 4);
    final r = math.min(size.width, size.height) / 2 - 34;
    final n = axes.length;
    Offset pt(int i, double v) {
      final ang = -math.pi / 2 + i * 2 * math.pi / n;
      return c + Offset(math.cos(ang), math.sin(ang)) * (r * v / 100);
    }

    final gridPaint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke;
    for (final k in [25.0, 50.0, 75.0, 100.0]) {
      final p = Path()..moveTo(pt(0, k).dx, pt(0, k).dy);
      for (var i = 1; i < n; i++) {
        p.lineTo(pt(i, k).dx, pt(i, k).dy);
      }
      p.close();
      canvas.drawPath(p, gridPaint..strokeWidth = k == 100 ? 1.5 : 1);
    }
    for (var i = 0; i < n; i++) {
      canvas.drawLine(c, pt(i, 100), gridPaint..strokeWidth = 1);
      final lp = pt(i, 122);
      final tp = TextPainter(
        text: TextSpan(text: axes[i], style: AppText.body(11.5, color: AppColors.greyLight, weight: FontWeight.w700)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, lp - Offset(tp.width / 2, tp.height / 2));
    }

    void dataset(List<double> v, Color color, double fillOpacity, double stroke) {
      final p = Path()..moveTo(pt(0, v[0] * t).dx, pt(0, v[0] * t).dy);
      for (var i = 1; i < n; i++) {
        p.lineTo(pt(i, v[i] * t).dx, pt(i, v[i] * t).dy);
      }
      p.close();
      canvas.drawPath(p, Paint()..color = fade(color, fillOpacity));
      canvas.drawPath(
          p,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke);
      for (var i = 0; i < n; i++) {
        canvas.drawCircle(pt(i, v[i] * t), 3, Paint()..color = color);
      }
    }

    dataset(b, AppColors.ronaldo, 0.18, 2);
    dataset(a, AppColors.gold, 0.22, 2.5);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) => old.t != t;
}
