import 'package:color_twist/core/theme/app_theme.dart';
import 'package:color_twist/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ColorTwistApp extends StatelessWidget {
  const ColorTwistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
