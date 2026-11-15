import 'package:flutter/material.dart';

import '../data/stats.dart';
import '../theme.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';
import '../widgets/vs_banner.dart';

class VersusTab extends StatefulWidget {
  const VersusTab({super.key});

  @override
  State<VersusTab> createState() => _VersusTabState();
}

class _VersusTabState extends State<VersusTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scroll = ScrollController();
  final _showPill = ValueNotifier(false);
  final _inNational = ValueNotifier(false);
  final _nationalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      _showPill.value = _scroll.offset > 190;
      final box = _nationalKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.attached) {
        // milli takım başlığı ekranın üst kısmına geldiyse etiketi değiştir
        _inNational.value = box.localToGlobal(Offset.zero).dy < 220;
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _showPill.dispose();
    _inNational.dispose();
    super.dispose();
  }

  static const _captions = [
    'Aynı lig, aynı dönem: 2009–2018 İspanya',
    'Duran toplar: iki farklı stil, iki farklı silah',
    'Topla buluşunca fark açılıyor',
    'Her dakikanın değeri',
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(children: [
      _list(),
      // Kaydırınca üstte sabit kalan "LALIGA YILLARI" etiketi
      Positioned(
        top: 10,
        left: 0,
        right: 0,
        child: ValueListenableBuilder<bool>(
          valueListenable: _showPill,
          builder: (_, show, child) => AnimatedSlide(
            offset: show ? Offset.zero : const Offset(0, -1.6),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(opacity: show ? 1 : 0, duration: const Duration(milliseconds: 200), child: child),
          ),
          child: Center(
            child: ValueListenableBuilder<bool>(
              valueListenable: _inNational,
              builder: (_, nat, __) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: nat ? const Color(0xFF75AADB) : AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: fade(Colors.black, 0.5), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Text(nat ? 'MİLLİ TAKIM · ARJANTİN vs PORTEKİZ' : 'LALIGA YILLARI · 2004–2021 / 2009–2018',
                    style: AppText.body(11.5, color: AppColors.black, weight: FontWeight.w900)),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _list() {
    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.only(bottom: 40),
      physics: const BouncingScrollPhysics(),
      children: [
        _hero(),
        const SectionTitle('Kulüp Kupaları', subtitle: 'İspanya yılları · Messi 2004–21 · Ronaldo 2009–18'),
        AppCard(
          child: Column(children: [
            const Legend(),
            const Divider(color: AppColors.line, height: 24),
            for (final s in clubTrophies) ScoreLine(s),
            const Divider(color: AppColors.line, height: 24),
            const ScoreLine(CompareStat('TOPLAM', 35, 15)),
          ]),
        ),
        const SectionTitle('Bireysel Ödüller', subtitle: 'İspanya\'da oynarken kazanılanlar'),
        AppCard(
          child: Column(children: [
            for (final s in individualAwards) ...[
              ScoreLine(s),
              if (s.note != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(s.note!, style: AppText.body(10.5, color: AppColors.grey)),
                ),
            ],
          ]),
        ),
        const SectionTitle('El Clásico', subtitle: 'Barcelona – Real Madrid'),
        _clasicoCard(),
        const SectionTitle('Aynı Sahada 9 Sezon', subtitle: 'LaLiga golleri · 2009/10 – 2017/18'),
        _seasonChart(),
        for (var i = 0; i < versusGroups.length; i++) ...[
          VsBanner(index: i + 1, caption: _captions[i % _captions.length]),
          SectionTitle(versusGroups[i].title, subtitle: versusGroups[i].subtitle),
          AppCard(
            child: Column(children: [
              const Legend(),
              const SizedBox(height: 6),
              for (final s in versusGroups[i].stats) CompareBar(s),
            ]),
          ),
        ],
        // ---------------- MİLLİ TAKIM ----------------
        _nationalHero(),
        const VsBanner(index: 1, national: true, caption: 'Arjantin 10  vs  Portekiz 7'),
        const SectionTitle('Milli Takım Kupaları', subtitle: 'Büyük turnuvalar · gençlik kupaları dahil değil'),
        AppCard(
          child: Column(children: [
            const _NationLegend(),
            const Divider(color: AppColors.line, height: 24),
            for (final t in nationalTrophies) ...[
              ScoreLine(t),
              if (t.note != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(t.note!, style: AppText.body(10.5, color: AppColors.grey)),
                ),
            ],
            const Divider(color: AppColors.line, height: 24),
            const ScoreLine(CompareStat('TOPLAM', 4, 3)),
          ]),
        ),
        for (var i = 0; i < nationalGroups.length; i++) ...[
          if (i > 0) const VsBanner(index: 2, national: true, caption: 'Altı Dünya Kupası, iki efsane'),
          SectionTitle(nationalGroups[i].title, subtitle: nationalGroups[i].subtitle),
          AppCard(
            child: Column(children: [
              const _NationLegend(),
              const SizedBox(height: 6),
              for (final s in nationalGroups[i].stats) CompareBar(s),
            ]),
          ),
        ],
      ],
    );
  }

  Widget _nationalHero() {
    Widget side(String name, String nation, String years, CrossAxisAlignment a, Color c) => Expanded(
          child: Column(crossAxisAlignment: a, children: [
            Text(name, style: AppText.display(32, color: c)),
            Text(nation, style: AppText.body(12, color: AppColors.greyLight, weight: FontWeight.w600)),
            Text(years, style: AppText.body(11, color: AppColors.grey)),
          ]),
        );
    return Container(
      key: _nationalKey,
      margin: const EdgeInsets.fromLTRB(16, 36, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.surface,
        border: Border.all(color: fade(const Color(0xFF75AADB), 0.5)),
      ),
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
            gradient: LinearGradient(colors: [Color(0xFF75AADB), Color(0xFFDCEBF7), Color(0xFFC8102E)]),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MİLLİ TAKIM', style: AppText.display(46, color: AppColors.black)),
            const SizedBox(height: 4),
            Text(
              'Arjantin vs Portekiz. Bu bölüm LaLiga değil, milli takım kariyerleridir. İkisi de 2026 Dünya Kupası\'ndan sonra milli takımı bıraktı.',
              style: AppText.body(12, color: const Color(0xFF111827), weight: FontWeight.w700),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            side('MESSI', 'Arjantin', '2005 – 2026 · 207 maç', CrossAxisAlignment.start, const Color(0xFF75AADB)),
            Text('VS', style: AppText.display(26, color: AppColors.grey)),
            side('RONALDO', 'Portekiz', '2003 – 2026 · 234 maç', CrossAxisAlignment.end, const Color(0xFFE5484D)),
          ]),
        ),
      ]),
    );
  }

  Widget _hero() {
    Widget side(String name, String club, String years, CrossAxisAlignment a, Color c) => Expanded(
          child: Column(crossAxisAlignment: a, children: [
            Text(name, style: AppText.display(32, color: c)),
            Text(club, style: AppText.body(12, color: AppColors.greyLight, weight: FontWeight.w600)),
            Text(years, style: AppText.body(11, color: AppColors.grey)),
          ]),
        );
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2206), AppColors.surface, Color(0xFF1C1C1F)],
        ),
        border: Border.all(color: fade(AppColors.gold, 0.35)),
      ),
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
          decoration: const BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('LALIGA YILLARI', style: AppText.display(46, color: AppColors.black)),
            const SizedBox(height: 4),
            Text(
              'Bu sekmedeki her şey sadece İspanya dönemini kapsar. Diğer kulüpler ve milli takımlar dahil değildir.',
              style: AppText.body(12, color: const Color(0xFF2A2206), weight: FontWeight.w700),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            side('MESSI', 'FC Barcelona', '2004 – 2021 · 17 sezon', CrossAxisAlignment.start, AppColors.gold),
            Text('VS', style: AppText.display(26, color: AppColors.grey)),
            side('RONALDO', 'Real Madrid', '2009 – 2018 · 9 sezon', CrossAxisAlignment.end, AppColors.white),
          ]),
        ),
      ]),
    );
  }

  Widget _clasicoCard() {
    final s = elClasico.first;
    return AppCard(
      child: Column(children: [
        Row(children: [
          Expanded(
            child: Column(children: [
              Text('${s.messi.toInt()}', style: AppText.display(64, color: AppColors.gold).copyWith(fontWeight: FontWeight.w900)),
              Text('MESSI', style: AppText.body(12, weight: FontWeight.w800)),
            ]),
          ),
          Column(children: [
            const Icon(Icons.sports_soccer, color: AppColors.grey, size: 22),
            const SizedBox(height: 4),
            Text('GOL', style: AppText.body(11, color: AppColors.grey, weight: FontWeight.w700)),
          ]),
          Expanded(
            child: Column(children: [
              Text('${s.ronaldo.toInt()}', style: AppText.display(52, color: AppColors.grey)),
              Text('RONALDO', style: AppText.body(12, weight: FontWeight.w800)),
            ]),
          ),
        ]),
        const SizedBox(height: 10),
        Text(s.note!, textAlign: TextAlign.center, style: AppText.body(12, color: AppColors.grey)),
      ]),
    );
  }

  Widget _seasonChart() {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(8, 20, 16, 12),
      child: Column(children: [
        const SeasonBarChart(labels: sharedSeasons, messi: messiSharedGoals, ronaldo: ronaldoSharedGoals),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Messi: 329 gol · 5 sezon önde',
                style: AppText.body(11.5, color: AppColors.gold, weight: FontWeight.w700)),
            Text('Ronaldo: 311', style: AppText.body(11.5, color: AppColors.greyLight)),
          ]),
        ),
      ]),
    );
  }
}

class _NationLegend extends StatelessWidget {
  const _NationLegend();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(t, style: AppText.body(12, weight: FontWeight.w700)),
        ]);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      dot(AppColors.gold, 'MESSI · ARJANTİN'),
      dot(AppColors.ronaldo, 'RONALDO · PORTEKİZ'),
    ]);
  }
}
