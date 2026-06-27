import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/core/theme/app_theme.dart';
import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ColorTwistApp extends StatefulWidget {
  const ColorTwistApp({super.key});

  @override
  State<ColorTwistApp> createState() => _ColorTwistAppState();
}

class _ColorTwistAppState extends State<ColorTwistApp> {
  GameplayTheme _theme = GameplayTheme.dark;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await AppServices.instance.storeService.loadTheme();
    if (mounted) setState(() => _theme = theme);
  }

  void refreshTheme() {
    _loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.forGameplayTheme(_theme),
      home: HomeScreen(onThemeChanged: _loadTheme),
    );
  }
}
