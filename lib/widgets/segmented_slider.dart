import 'package:flutter/material.dart';

import '../theme.dart';

/// PageView ile senkron kayan segmented kontrol.
/// Gösterge, sayfa kaydırılırken parmağı takip eder.
class SegmentedSlider extends StatelessWidget {
  final PageController controller;
  final List<String> labels;
  final ValueChanged<int> onTap;

  const SegmentedSlider({
    super.key,
    required this.controller,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: LayoutBuilder(builder: (context, box) {
        final segW = box.maxWidth / labels.length;
        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final page = controller.hasClients && controller.position.haveDimensions
                ? (controller.page ?? controller.initialPage.toDouble())
                : controller.initialPage.toDouble();
            return Stack(children: [
              Positioned(
                left: page * segW,
                top: 0,
                bottom: 0,
                width: segW,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.gold, AppColors.goldDeep],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: fade(AppColors.gold, 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (i) {
                  final t = (1 - (page - i).abs()).clamp(0.0, 1.0);
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onTap(i),
                      child: Center(
                        child: Text(
                          labels[i],
                          style: AppText.body(13,
                              weight: FontWeight.w800,
                              color: Color.lerp(AppColors.grey, AppColors.black, t)!),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ]);
          },
        );
      }),
    );
  }
}
