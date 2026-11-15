import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// 5 kümeli Venn: Gol, Asist, Frikik, Oyun Kuruculuk, Kupa (tüm zamanlar).
/// Her kümede ilk 3 oyuncu; Messi beşinin kesişiminde.
class VennSet {
  final String title;
  final String scope;
  final Color color;
  final List<(String, String, String)> top3; // (sıra, isim, değer)
  final Offset center; // elips merkezi — 370x335 tasarım alanında
  final double rot; // derece
  final Offset labelPos; // kümenin yalnız kendine ait bölgesi
  final List<String> others; // Messi dışındaki, yalnız bu kümede olanlar
  const VennSet(this.title, this.scope, this.color, this.top3, this.center, this.rot, this.labelPos, this.others);
}

const vennW = 370.0, vennH = 335.0, vennRx = 133.0, vennRy = 68.0;

const vennSets = <VennSet>[
  VennSet('ASİST', 'Kariyer asisti', Color(0xFF3DDC97),
      [('1', 'Messi', '420+'), ('2', 'Puskás', '404'), ('3', 'Pelé', '369')],
      Offset(180, 133), -74, Offset(204, 45), ['Puskás']),
  VennSet('KUPA', 'Kariyer boyunca kazanılan kupa', Color(0xFFC08BFF),
      [('1', 'Messi', '45+'), ('2', 'Dani Alves', '43'), ('3', 'Marquinhos', '42+')],
      Offset(217.1, 159.9), -2, Offset(308, 159), ['D. Alves', 'Marquinhos']),
  VennSet('FRİKİK', 'Frikik golü', Color(0xFFFF6B5E),
      [('1', 'Juninho', '77'), ('2', 'Messi', '71'), ('3', 'Pelé', '')],
      Offset(202.9, 203.6), 70, Offset(232, 291), ['Juninho']),
  VennSet('GOL', 'Resmi maç golü', Color(0xFFF5C518),
      [('1', 'Ronaldo', '978'), ('2', 'Messi', '921'), ('3', 'Pelé', '770')],
      Offset(157.1, 203.6), 142, Offset(84, 255), ['Ronaldo']),
  VennSet('OYUN KURUCU', 'IFFHS En İyi Oyun Kurucu', Color(0xFF4FA3FF),
      [('1', 'Messi', '5×'), ('2', 'Xavi', '4×'), ('3', 'De Bruyne', '')],
      Offset(142.9, 159.9), 214, Offset(68, 109), ['Xavi', 'De Bruyne']),
];

/// Birden fazla kümede olan (Messi hariç) oyuncu: Pelé → ASİST ∩ FRİKİK ∩ GOL
const vennPele = Offset(160, 253);
const vennMessi = Offset(178, 169);

class VennDiagram extends StatefulWidget {
  const VennDiagram({super.key});

  @override
  State<VennDiagram> createState() => _VennDiagramState();
}

class _VennDiagramState extends State<VennDiagram> with SingleTickerProviderStateMixin {
  int? _focus; // seçili küme
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      LayoutBuilder(builder: (context, box) {
        final s = box.maxWidth / vennW;
        return SizedBox(
          width: box.maxWidth,
          height: vennH * s,
          child: Stack(clipBehavior: Clip.none, children: [
            Positioned.fill(child: CustomPaint(painter: _VennPainter(_focus, s))),
            for (var i = 0; i < vennSets.length; i++)
              Positioned(
                left: vennSets[i].labelPos.dx * s - 50 * s,
                top: vennSets[i].labelPos.dy * s - (10 + vennSets[i].others.length * 7) * s,
                width: 100 * s,
                child: GestureDetector(
                  onTap: () => setState(() => _focus = _focus == i ? null : i),
                  child: Column(children: [
                    Text(vennSets[i].title,
                        textAlign: TextAlign.center,
                        style: AppText.display(17 * s, color: vennSets[i].color)
                            .copyWith(decoration: _focus == i ? TextDecoration.underline : null)),
                    for (final n in vennSets[i].others)
                      Text(n,
                          textAlign: TextAlign.center,
                          style: AppText.body(10 * s, color: AppColors.white, weight: FontWeight.w800)),
                  ]),
                ),
              ),
            Positioned(
              left: vennPele.dx * s - 20 * s,
              top: vennPele.dy * s - 7 * s,
              width: 40 * s,
              child: Text('Pelé',
                  textAlign: TextAlign.center,
                  style: AppText.body(9.5 * s, color: AppColors.white, weight: FontWeight.w900)),
            ),
            // Messi: beş kümenin kesişimi
            Positioned(
              left: vennMessi.dx * s - 40 * s,
              top: vennMessi.dy * s - 40 * s,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Container(
                  width: 80 * s,
                  height: 80 * s,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.black,
                    border: Border.all(color: AppColors.gold, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: fade(AppColors.gold, 0.25 + 0.3 * _pulse.value),
                        blurRadius: 14 + 12 * _pulse.value,
                      ),
                    ],
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('MESSI', style: AppText.display(22 * s, color: AppColors.gold)),
                    Text('5 / 5', style: AppText.body(9.5 * s, color: AppColors.grey, weight: FontWeight.w700)),
                  ]),
                ),
              ),
            ),
          ]),
        );
      }),
      const SizedBox(height: 12),
      for (var i = 0; i < vennSets.length; i++) _legend(i),
    ]);
  }

  Widget _legend(int i) {
    final v = vennSets[i];
    final on = _focus == null || _focus == i;
    return GestureDetector(
      onTap: () => setState(() => _focus = _focus == i ? null : i),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: on ? 1 : 0.4,
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: v.color, width: 4)),
          ),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(v.title, style: AppText.display(18, color: v.color)),
                Text(v.scope, style: AppText.body(10.5, color: AppColors.grey)),
              ]),
            ),
            for (final (rank, name, val) in v.top3)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(children: [
                  Text('#$rank', style: AppText.body(9.5, color: AppColors.grey, weight: FontWeight.w800)),
                  Text(name,
                      style: AppText.body(11.5,
                          color: name == 'Messi' ? AppColors.gold : AppColors.white, weight: FontWeight.w800)),
                  if (val.isNotEmpty) Text(val, style: AppText.body(10, color: AppColors.grey)),
                ]),
              ),
          ]),
        ),
      ),
    );
  }
}

class _VennPainter extends CustomPainter {
  final int? focus;
  final double s;
  _VennPainter(this.focus, this.s);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < vennSets.length; i++) {
      final v = vennSets[i];
      final dim = focus != null && focus != i;
      canvas.save();
      canvas.translate(v.center.dx * s, v.center.dy * s);
      canvas.rotate(v.rot * math.pi / 180);
      final r = Rect.fromCenter(center: Offset.zero, width: vennRx * 2 * s, height: vennRy * 2 * s);
      canvas.drawOval(r, Paint()..color = fade(v.color, dim ? 0.03 : (focus == i ? 0.28 : 0.12)));
      canvas.drawOval(
          r,
          Paint()
            ..color = fade(v.color, dim ? 0.25 : 0.9)
            ..style = PaintingStyle.stroke
            ..strokeWidth = focus == i ? 3 : 2);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _VennPainter old) => old.focus != focus || old.s != s;
}
