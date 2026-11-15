import 'package:flutter/material.dart';

import '../data/stats.dart';
import '../theme.dart';
import '../widgets/charts.dart';
import '../widgets/common.dart';

/// Tarihi rekorlar — inanılması güç sayılar
class RecordsTab extends StatefulWidget {
  const RecordsTab({super.key});

  @override
  State<RecordsTab> createState() => _RecordsTabState();
}

class _RecordsTabState extends State<RecordsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RecordCat? _filter; // null = tümü
  AwardCat? _awardFilter;

  static const _chips = <(String, RecordCat?)>[
    ('TÜMÜ', null),
    ('LALIGA', RecordCat.laliga),
    ('AVRUPA', RecordCat.europe),
    ('DÜNYA', RecordCat.world),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final heroes = records.where((r) => r.hero).toList();
    final rest = records.where((r) => !r.hero && (_filter == null || r.cat == _filter)).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 40),
      physics: const BouncingScrollPhysics(),
      children: [
        const SectionTitle('Unbelievable', subtitle: 'Kırılması neredeyse imkânsız gol rekorları'),
        for (final r in heroes) _heroRecord(r),
        const SectionTitle('LaLiga Gol Yolculuğu', subtitle: '2004/05 – 2020/21 · sezon başına gol'),
        _lineChart(),
        SectionTitle('Rekor Defteri', subtitle: '${rest.length} rekor'),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _chips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final (label, cat) = _chips[i];
              final on = _filter == cat;
              return GestureDetector(
                onTap: () => setState(() => _filter = cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: on ? AppColors.gold : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: on ? AppColors.gold : AppColors.line),
                  ),
                  child: Text(label,
                      style: AppText.body(12, weight: FontWeight.w800, color: on ? AppColors.black : AppColors.grey)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: GridView.builder(
              key: ValueKey(_filter),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rest.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemBuilder: (_, i) => _recordTile(rest[i]),
            ),
          ),
        ),
        ..._awardsSection(),
      ],
    );
  }

  List<Widget> _awardsSection() {
    final list = awards.where((a) => _awardFilter == null || a.cat == _awardFilter).toList();
    final chips = <(String, AwardCat?)>[('TÜMÜ', null), for (final e in awardCatLabels.entries) (e.value, e.key)];
    return [
      const SectionTitle('Bireysel Ödüller', subtitle: 'Büyük bireysel ödüller ve kaç kez kazandığı'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          for (var i = 0; i < bigThreeAwards.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: _bigAward(bigThreeAwards[i])),
          ],
        ]),
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final (label, cat) = chips[i];
            final on = _awardFilter == cat;
            return GestureDetector(
              onTap: () => setState(() => _awardFilter = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: on ? AppColors.gold : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: on ? AppColors.gold : AppColors.line),
                ),
                child: Text(label,
                    style: AppText.body(12, weight: FontWeight.w800, color: on ? AppColors.black : AppColors.grey)),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(children: [
          for (var i = 0; i < list.length; i++) ...[
            if (i > 0) const Divider(color: AppColors.line, height: 1),
            _awardRow(list[i]),
          ],
        ]),
      ),
    ];
  }

  Widget _bigAward(AwardItem a) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3A2E05), Color(0xFF151517)],
        ),
        border: Border.all(color: fade(AppColors.gold, 0.45)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.emoji_events_rounded, color: AppColors.gold, size: 22),
        const Spacer(),
        Text(a.count, style: AppText.display(56, color: AppColors.gold)),
        Text(a.name, maxLines: 2, style: AppText.body(12, color: AppColors.white, weight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(a.note ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.body(9.5, color: AppColors.grey)),
      ]),
    );
  }

  Widget _awardRow(AwardItem a) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fade(AppColors.gold, 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: fade(AppColors.gold, 0.35)),
          ),
          child: Text('${a.count}×', style: AppText.display(26, color: AppColors.gold)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.name, style: AppText.body(13.5, color: AppColors.white, weight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(a.years, style: AppText.body(11.5, color: AppColors.grey, weight: FontWeight.w600)),
            if (a.note != null)
              Text(a.note!, style: AppText.body(11, color: fade(AppColors.gold, 0.85), weight: FontWeight.w600)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surfaceHigh, borderRadius: BorderRadius.circular(8)),
          child: Text(awardCatLabels[a.cat]!, style: AppText.body(9.5, color: AppColors.grey, weight: FontWeight.w800)),
        ),
      ]),
    );
  }

  Widget _heroRecord(RecordItem r) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2206), Color(0xFF121214)],
        ),
        border: Border.all(color: fade(AppColors.gold, 0.35)),
      ),
      child: Row(children: [
        SizedBox(
          width: 118,
          child: int.tryParse(r.number) == null
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(r.number, style: AppText.display(78, color: AppColors.gold)),
                )
              : TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: double.parse(r.number)),
                  duration: const Duration(milliseconds: 1400),
                  curve: Curves.easeOutExpo,
                  builder: (_, v, __) => Text('${v.round()}', style: AppText.display(78, color: AppColors.gold)),
                ),
        ),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.title.toUpperCase(), style: AppText.display(22)),
            const SizedBox(height: 6),
            Text(r.detail, style: AppText.body(12, color: AppColors.grey)),
          ]),
        ),
      ]),
    );
  }

  Widget _recordTile(RecordItem r) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.emoji_events_rounded, color: AppColors.gold, size: 20),
        const Spacer(),
        Text(r.number, style: AppText.display(46, color: AppColors.white)),
        Text(r.title, style: AppText.body(12.5, color: AppColors.gold, weight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(r.detail, maxLines: 4, overflow: TextOverflow.ellipsis, style: AppText.body(10.5, color: AppColors.grey)),
      ]),
    );
  }

  Widget _lineChart() {
    return const AppCard(
      padding: EdgeInsets.fromLTRB(8, 20, 16, 12),
      child: GoalsLineChart(labels: messiAllSeasons, values: messiAllGoals),
    );
  }
}
