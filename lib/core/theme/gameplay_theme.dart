import 'package:color_twist/core/constants/game_constants.dart';
import 'package:flutter/material.dart';

class GameplayTheme {
  const GameplayTheme({
    required this.id,
    required this.name,
    required this.scaffoldColor,
    required this.backgroundGradient,
    required this.parallaxBandColors,
    required this.gameColors,
    required this.particleColors,
    required this.accentColor,
    this.statusBarBrightness = Brightness.dark,
  });

  final String id;
  final String name;
  final Color scaffoldColor;
  final List<Color> backgroundGradient;
  final List<Color> parallaxBandColors;
  final List<Color> gameColors;
  final List<Color> particleColors;
  final Color accentColor;
  final Brightness statusBarBrightness;

  static GameplayTheme get dark => gameplayThemes.firstWhere((t) => t.id == 'dark');

  static List<GameplayTheme> get all => gameplayThemes;

  static GameplayTheme byId(String id) {
    return gameplayThemes.firstWhere(
      (t) => t.id == id,
      orElse: () => dark,
    );
  }

  bool get isLightTheme => statusBarBrightness == Brightness.light;

  Color get primaryTextColor => isLightTheme ? Colors.black87 : Colors.white;

  Color get secondaryTextColor => isLightTheme ? Colors.black54 : Colors.white70;

  Color get subtleBorderColor => isLightTheme ? Colors.black12 : Colors.white12;

  Color get cardSurfaceColor => isLightTheme
      ? Colors.white.withValues(alpha: 0.85)
      : scaffoldColor.withValues(alpha: 0.8);
}

const gameplayThemes = [
  GameplayTheme(
    id: 'dark',
    name: 'Dark',
    scaffoldColor: Color(0xFF0C0C18),
    backgroundGradient: [
      Color(0xFF1B1B2F),
      Color(0xFF141428),
      Color(0xFF0C0C18),
    ],
    parallaxBandColors: [
      Color(0x18E94560),
      Color(0x1800ADB5),
      Color(0x18FFC947),
      Color(0x184833D4),
    ],
    gameColors: GameConstants.defaultGameColors,
    particleColors: [
      Color(0xFFFFD700),
      Color(0xFFFF6B6B),
      Color(0xFF4ECDC4),
      Color(0xFF45B7D1),
    ],
    accentColor: Color(0xFFFFD700),
  ),
  GameplayTheme(
    id: 'neon',
    name: 'Neon',
    scaffoldColor: Color(0xFF050508),
    backgroundGradient: [
      Color(0xFF0A0A12),
      Color(0xFF080810),
      Color(0xFF050508),
    ],
    parallaxBandColors: [
      Color(0x30FF006E),
      Color(0x3000F5FF),
      Color(0x3039FF14),
      Color(0x30FFFF00),
    ],
    gameColors: [
      Color(0xFFFF006E),
      Color(0xFF00F5FF),
      Color(0xFF39FF14),
      Color(0xFFFFFF00),
    ],
    particleColors: [
      Color(0xFFFF006E),
      Color(0xFF00F5FF),
      Color(0xFF39FF14),
      Color(0xFFFFFF00),
    ],
    accentColor: Color(0xFF00F5FF),
  ),
  GameplayTheme(
    id: 'space',
    name: 'Space',
    scaffoldColor: Color(0xFF0A0E1A),
    backgroundGradient: [
      Color(0xFF141B3A),
      Color(0xFF0E1428),
      Color(0xFF0A0E1A),
    ],
    parallaxBandColors: [
      Color(0x204B6CB7),
      Color(0x206A5ACD),
      Color(0x203498DB),
      Color(0x208A2BE2),
    ],
    gameColors: [
      Color(0xFF6A5ACD),
      Color(0xFF3498DB),
      Color(0xFF9B59B6),
      Color(0xFF1ABC9C),
    ],
    particleColors: [
      Color(0xFF6A5ACD),
      Color(0xFF3498DB),
      Color(0xFFE8F4FF),
      Color(0xFF9B59B6),
    ],
    accentColor: Color(0xFF3498DB),
  ),
  GameplayTheme(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    scaffoldColor: Color(0xFF12001A),
    backgroundGradient: [
      Color(0xFF1A0028),
      Color(0xFF140020),
      Color(0xFF12001A),
    ],
    parallaxBandColors: [
      Color(0x28FF00FF),
      Color(0x2800FFFF),
      Color(0x28FFFF00),
      Color(0x2800FF00),
    ],
    gameColors: [
      Color(0xFFFF00FF),
      Color(0xFF00FFFF),
      Color(0xFFFFFF00),
      Color(0xFF00FF00),
    ],
    particleColors: [
      Color(0xFFFF00FF),
      Color(0xFF00FFFF),
      Color(0xFFFFFF00),
      Color(0xFFFF0066),
    ],
    accentColor: Color(0xFFFF00FF),
  ),
  GameplayTheme(
    id: 'pastel',
    name: 'Pastel',
    scaffoldColor: Color(0xFFF5F0FF),
    backgroundGradient: [
      Color(0xFFFFE8F0),
      Color(0xFFF0E8FF),
      Color(0xFFE8F4FF),
    ],
    parallaxBandColors: [
      Color(0x40FFB6C1),
      Color(0x40B5EAD7),
      Color(0x40C7CEEA),
      Color(0x40FFDAC1),
    ],
    gameColors: [
      Color(0xFFFF8FAB),
      Color(0xFF7FDBCA),
      Color(0xFFA8B5E8),
      Color(0xFFFFBE98),
    ],
    particleColors: [
      Color(0xFFFFB6C1),
      Color(0xFFB5EAD7),
      Color(0xFFC7CEEA),
      Color(0xFFFFDAC1),
    ],
    accentColor: Color(0xFFFF8FAB),
    statusBarBrightness: Brightness.light,
  ),
  GameplayTheme(
    id: 'halloween',
    name: 'Halloween',
    scaffoldColor: Color(0xFF1A0A00),
    backgroundGradient: [
      Color(0xFF2D1500),
      Color(0xFF1F0D00),
      Color(0xFF1A0A00),
    ],
    parallaxBandColors: [
      Color(0x30FF6600),
      Color(0x308B008B),
      Color(0x3000AA00),
      Color(0x30222222),
    ],
    gameColors: [
      Color(0xFFFF6600),
      Color(0xFF8B008B),
      Color(0xFF00AA00),
      Color(0xFF444444),
    ],
    particleColors: [
      Color(0xFFFF6600),
      Color(0xFF8B008B),
      Color(0xFFFFAA00),
      Color(0xFF00AA00),
    ],
    accentColor: Color(0xFFFF6600),
  ),
  GameplayTheme(
    id: 'winter',
    name: 'Winter',
    scaffoldColor: Color(0xFF0A1520),
    backgroundGradient: [
      Color(0xFF1A3050),
      Color(0xFF122840),
      Color(0xFF0A1520),
    ],
    parallaxBandColors: [
      Color(0x30AADDFF),
      Color(0x30E8F4FF),
      Color(0x30B0C4DE),
      Color(0x3040E0D0),
    ],
    gameColors: [
      Color(0xFF87CEEB),
      Color(0xFFE8F4FF),
      Color(0xFFB0C4DE),
      Color(0xFF40E0D0),
    ],
    particleColors: [
      Color(0xFFE8F4FF),
      Color(0xFF87CEEB),
      Color(0xFFB0C4DE),
      Color(0xFF40E0D0),
    ],
    accentColor: Color(0xFF87CEEB),
  ),
];
