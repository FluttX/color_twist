import 'package:color_twist/core/constants/game_constants.dart';
import 'package:flutter/material.dart';

class GameConfig {
  const GameConfig({
    this.gameColors = GameConstants.defaultGameColors,
    this.gravity = GameConstants.defaultGravity,
    this.jumpSpeed = GameConstants.defaultJumpSpeed,
  });

  final List<Color> gameColors;
  final double gravity;
  final double jumpSpeed;
}
