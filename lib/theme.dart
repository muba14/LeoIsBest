import 'package:flutter/material.dart';

/// leoisbest renk paleti: siyah - sarı - gri
class AppColors {
  static const black = Color(0xFF0B0B0C);
  static const surface = Color(0xFF151517);
  static const surfaceHigh = Color(0xFF1E1E21);
  static const line = Color(0xFF2A2A2E);
  static const gold = Color(0xFFF5C518);
  static const goldDeep = Color(0xFFC99A06);
  static const grey = Color(0xFF9A9AA0);
  static const greyLight = Color(0xFFD7D7DB);
  static const ronaldo = Color(0xFF8E8E95);
  static const white = Color(0xFFF4F4F5);
}

/// Fontlar uygulamanın içinde (assets/fonts) — internet gerekmez.
class AppText {
  static const _display = 'BebasNeue';
  static const _body = 'Inter';

  static TextStyle display(double size, {Color color = AppColors.white}) => TextStyle(
        fontFamily: _display,
        fontSize: size,
        color: color,
        letterSpacing: 1.2,
        height: 1.0,
      );

  static TextStyle body(
    double size, {
    Color color = AppColors.greyLight,
    FontWeight weight = FontWeight.w500,
  }) =>
      TextStyle(
        fontFamily: _body,
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: 1.35,
      );
}

/// Opaklık yardımcısı (withOpacity yerine, yeni Flutter sürümleriyle uyumlu)
Color fade(Color c, double opacity) => c.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.black,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.gold,
      secondary: AppColors.grey,
      surface: AppColors.surface,
    ),
    textTheme: base.textTheme.apply(fontFamily: 'Inter'),
    splashColor: fade(AppColors.gold, 0.08),
    highlightColor: Colors.transparent,
  );
}
