import 'dart:async';

import 'package:flutter/material.dart';

import '../data/stats.dart';
import '../theme.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';
import '../widgets/venn_diagram.dart';

/// "Why Messi is complete" — oyun kurucu + golcü + duran top ustası + çalımcı
class CompleteTab extends StatefulWidget {
  const CompleteTab({super.key});

  @override
  State<CompleteTab> createState() => _CompleteTabState();
}

class _CompleteTabState extends State<CompleteTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      physics: const BouncingScrollPhysics(),
      children: [
        _hero(),
        const SectionTitle('Komple Oyuncu Haritası', subtitle: 'Göreli endeks · 2009–2018 verisi · lider = 100'),
        _radar(),
        const SectionTitle('Beş Kümenin Kesişimi', subtitle: 'Tüm zamanlar · her kümede ilk 3 · beşinde birden olan tek isim: Messi'),
        const AppCard(child: VennDiagram()),
        const SectionTitle('4 Oyuncu, Tek Forma'),
        for (var i = 0; i < pillars.length; i++) _pillarCard(pillars[i], i),
        const SectionTitle('Onun Hakkında Söylenenler', subtitle: 'Hocalar, rakipler ve takım arkadaşları'),
        const QuoteCarousel(),
      ],
    );
  }

  Widget _hero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold, AppColors.goldDeep],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('WHY MESSI\nIS COMPLETE', style: AppText.display(44, color: AppColors.black)),
        const SizedBox(height: 10),
        Text(
          'Most greats are one thing. A scorer, a creator, a dribbler, a free-kick specialist. '
          'Leo is all of them, at the very top, at the same time.',
          style: AppText.body(13.5, color: const Color(0xFF2A2206), weight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in ['Playmaker', 'Finisher', 'Set-piece', 'Dribbler'])
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(t, style: AppText.body(11.5, color: AppColors.gold, weight: FontWeight.w800)),
            ),
        ]),
      ]),
    );
  }

  Widget _radar() {
    return const AppCard(
      padding: EdgeInsets.fromLTRB(12, 18, 12, 16),
      child: Column(children: [
        RadarChart(axes: radarAxes, a: radarMessi, b: radarRonaldo),
        SizedBox(height: 8),
        Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Legend()),
      ]),
    );
  }

  Widget _pillarCard(Pillar p, int i) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('0${i + 1}', style: AppText.display(18, color: AppColors.grey)),
            const SizedBox(width: 10),
            Text(p.title, style: AppText.display(24, color: AppColors.gold)),
          ]),
          const SizedBox(height: 4),
          Text(p.tagline, style: AppText.body(13, color: AppColors.white, weight: FontWeight.w600).copyWith(fontStyle: FontStyle.italic)),
          const SizedBox(height: 14),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(p.bigNumber, style: AppText.display(58, color: AppColors.white)),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(p.bigLabel, style: AppText.body(12, color: AppColors.grey, weight: FontWeight.w600)),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          for (final f in p.facts)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Icon(Icons.circle, size: 6, color: AppColors.gold),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(f, style: AppText.body(12.5))),
              ]),
            ),
        ]),
      ),
    );
  }
}

/// Kendi kendine dönen, kaydırılabilir söz kartları
class QuoteCarousel extends StatefulWidget {
  const QuoteCarousel({super.key});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  final _ctrl = PageController(viewportFraction: 0.88);
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_ctrl.hasClients) return;
      final next = (_index + 1) % quotes.length;
      _ctrl.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 230,
        child: PageView.builder(
          controller: _ctrl,
          itemCount: quotes.length,
          onPageChanged: (i) => setState(() => _index = i),
          itemBuilder: (_, i) {
            final q = quotes[i];
            return AnimatedScale(
              scale: i == _index ? 1 : 0.94,
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(22),
                  border: const Border(left: BorderSide(color: AppColors.gold, width: 4)),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('“', style: AppText.display(54, color: AppColors.gold)),
                  Expanded(
                    child: Text(q.text, style: AppText.body(16.5, color: AppColors.white, weight: FontWeight.w700)),
                  ),
                  Text('— ${q.author}', style: AppText.body(13, color: AppColors.gold, weight: FontWeight.w800)),
                  Text(q.role, style: AppText.body(11, color: AppColors.grey)),
                ]),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < quotes.length; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == _index ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == _index ? AppColors.gold : AppColors.line,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ]),
    ]);
  }
}
