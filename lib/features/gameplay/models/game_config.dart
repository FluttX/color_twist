import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/store/models/player_appearance.dart';
import 'package:flutter/material.dart';

class GameConfig {
  GameConfig({
    List<Color>? gameColors,
    this.gravity = GameConstants.defaultGravity,
    this.jumpSpeed = GameConstants.defaultJumpSpeed,
    this.cameraFollowSpeed = GameConstants.defaultCameraFollowSpeed,
    this.cameraLookAhead = GameConstants.defaultCameraLookAhead,
    this.cameraJumpBounce = GameConstants.defaultCameraJumpBounce,
    this.cameraBounceDuration = GameConstants.defaultCameraBounceDuration,
    this.appearance = const PlayerAppearance(),
    GameplayTheme? theme,
  })  : gameColors = gameColors ?? GameConstants.defaultGameColors,
        theme = theme ?? GameplayTheme.dark;

  final List<Color> gameColors;
  final double gravity;
  final double jumpSpeed;
  final double cameraFollowSpeed;
  final double cameraLookAhead;
  final double cameraJumpBounce;
  final double cameraBounceDuration;
  final PlayerAppearance appearance;
  final GameplayTheme theme;

  GameConfig copyWith({
    List<Color>? gameColors,
    PlayerAppearance? appearance,
    GameplayTheme? theme,
  }) {
    return GameConfig(
      gameColors: gameColors ?? this.gameColors,
      gravity: gravity,
      jumpSpeed: jumpSpeed,
      cameraFollowSpeed: cameraFollowSpeed,
      cameraLookAhead: cameraLookAhead,
      cameraJumpBounce: cameraJumpBounce,
      cameraBounceDuration: cameraBounceDuration,
      appearance: appearance ?? this.appearance,
      theme: theme ?? this.theme,
    );
  }
}
