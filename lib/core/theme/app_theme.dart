import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get dark => forGameplayTheme(GameplayTheme.dark);

  static ThemeData forGameplayTheme(GameplayTheme theme) {
    final isLight = theme.statusBarBrightness == Brightness.light;
    final textColor = isLight ? Colors.black87 : Colors.white;
    final mutedText = isLight ? Colors.black54 : Colors.white70;

    return ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: theme.scaffoldColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: theme.accentColor,
        brightness: isLight ? Brightness.light : Brightness.dark,
        surface: theme.scaffoldColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: theme.scaffoldColor,
        foregroundColor: textColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: mutedText),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: theme.accentColor,
          foregroundColor: isLight ? Colors.black87 : Colors.black,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.accentColor,
          side: BorderSide(color: theme.accentColor),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: theme.accentColor.withValues(alpha: 0.3),
        labelStyle: TextStyle(color: textColor),
        side: BorderSide(color: theme.subtleBorderColor),
      ),
      iconTheme: IconThemeData(color: textColor),
      dividerColor: theme.subtleBorderColor,
      cardTheme: CardThemeData(
        color: theme.cardSurfaceColor,
        elevation: isLight ? 1 : 0,
      ),
    );
  }
}
