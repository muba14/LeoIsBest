import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_shell.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.black,
  ));
  runApp(const LeoIsBestApp());
}

class LeoIsBestApp extends StatelessWidget {
  const LeoIsBestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'leoisbest',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomeShell(),
    );
  }
}
