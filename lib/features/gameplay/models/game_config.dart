import 'package:color_twist/core/constants/game_constants.dart';
import 'package:flutter/material.dart';

class GameConfig {
  const GameConfig({
    this.gameColors = GameConstants.defaultGameColors,
    this.gravity = GameConstants.defaultGravity,
    this.jumpSpeed = GameConstants.defaultJumpSpeed,
    this.cameraFollowSpeed = GameConstants.defaultCameraFollowSpeed,
    this.cameraLookAhead = GameConstants.defaultCameraLookAhead,
    this.cameraJumpBounce = GameConstants.defaultCameraJumpBounce,
    this.cameraBounceDuration = GameConstants.defaultCameraBounceDuration,
  });

  final List<Color> gameColors;
  final double gravity;
  final double jumpSpeed;
  final double cameraFollowSpeed;
  final double cameraLookAhead;
  final double cameraJumpBounce;
  final double cameraBounceDuration;
}
