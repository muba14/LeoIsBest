import 'package:flutter/material.dart';

import '../data/stats.dart';
import '../theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle(this.title, {super.key, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 22, decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Expanded(child: Text(title.toUpperCase(), style: AppText.display(26))),
        ]),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 4),
            child: Text(subtitle!, style: AppText.body(12, color: AppColors.grey)),
          ),
      ]),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}

/// Messi | etiket | Ronaldo — önde olanın sayısı kalın ve renkli.
class ScoreLine extends StatelessWidget {
  final CompareStat stat;
  const ScoreLine(this.stat, {super.key});

  @override
  Widget build(BuildContext context) {
    final l = stat.leader;
    TextStyle numStyle(bool lead, Color c) => AppText.display(lead ? 30 : 26,
        color: lead ? c : fade(AppColors.grey, 0.7));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        SizedBox(
          width: 52,
          child: Text(stat.fmt(stat.messi),
              style: numStyle(l >= 0, AppColors.gold).copyWith(
                  fontWeight: l == 1 ? FontWeight.w900 : FontWeight.w400)),
        ),
        Expanded(
          child: Text(stat.label,
              textAlign: TextAlign.center,
              style: AppText.body(13, color: AppColors.greyLight, weight: FontWeight.w600)),
        ),
        SizedBox(
          width: 52,
          child: Text(stat.fmt(stat.ronaldo),
              textAlign: TextAlign.right,
              style: numStyle(l <= 0, AppColors.white).copyWith(
                  fontWeight: l == -1 ? FontWeight.w900 : FontWeight.w400)),
        ),
      ]),
    );
  }
}

/// Animasyonlu iki taraflı karşılaştırma çubuğu.
class CompareBar extends StatelessWidget {
  final CompareStat stat;
  const CompareBar(this.stat, {super.key});

  @override
  Widget build(BuildContext context) {
    final total = stat.messi + stat.ronaldo;
    // lowerIsBetter ise oranı ters çevir ki iyi olan daha uzun görünsün
    double mShare = total == 0 ? 0.5 : stat.messi / total;
    if (stat.lowerIsBetter) mShare = 1 - mShare;
    final l = stat.leader;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Row(children: [
          Text(stat.fmt(stat.messi),
              style: AppText.body(17,
                  color: l >= 0 ? AppColors.gold : AppColors.grey,
                  weight: l == 1 ? FontWeight.w900 : FontWeight.w500)),
          Expanded(
            child: Text(stat.label,
                textAlign: TextAlign.center,
                style: AppText.body(12.5, color: AppColors.greyLight, weight: FontWeight.w600)),
          ),
          Text(stat.fmt(stat.ronaldo),
              style: AppText.body(17,
                  color: l <= 0 ? AppColors.white : AppColors.grey,
                  weight: l == -1 ? FontWeight.w900 : FontWeight.w500)),
        ]),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: mShare),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) => ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(children: [
                Expanded(
                  flex: (v * 1000).round().clamp(1, 999),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.goldDeep,
                        l >= 0 ? AppColors.gold : fade(AppColors.goldDeep, 0.6),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  flex: ((1 - v) * 1000).round().clamp(1, 999),
                  child: Container(color: l <= 0 ? AppColors.ronaldo : AppColors.line),
                ),
              ]),
            ),
          ),
        ),
        if (stat.note != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(stat.note!, style: AppText.body(11, color: AppColors.grey)),
          ),
      ]),
    );
  }
}

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, String t) => Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(t, style: AppText.body(12, weight: FontWeight.w700)),
        ]);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      dot(AppColors.gold, 'MESSI'),
      dot(AppColors.ronaldo, 'RONALDO'),
    ]);
  }
}
