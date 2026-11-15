import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/segmented_slider.dart';
import 'complete_tab.dart';
import 'records_tab.dart';
import 'versus_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/icon/app_icon.png', width: 42, height: 42, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: 'leo', style: AppText.display(30)),
                      TextSpan(text: 'is', style: AppText.display(30, color: AppColors.grey)),
                      TextSpan(text: 'best', style: AppText.display(30, color: AppColors.gold)),
                    ]),
                  ),
                  Text('Why he is the GOAT', style: AppText.body(11.5, color: AppColors.grey)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: fade(AppColors.gold, 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: fade(AppColors.gold, 0.4)),
                ),
                child: Text('#10', style: AppText.display(16, color: AppColors.gold)),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedSlider(
              controller: _pages,
              labels: const ['VERSUS', 'WHY LEO', 'RECORDS'],
              onTap: (i) => _pages.animateToPage(i,
                  duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: PageView(
              controller: _pages,
              physics: const BouncingScrollPhysics(),
              children: const [VersusTab(), CompleteTab(), RecordsTab()],
            ),
          ),
        ]),
      ),
    );
  }
}
