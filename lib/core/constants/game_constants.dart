import 'package:flutter/material.dart';

abstract final class GameConstants {
  static const double cameraWidth = 600;
  static const double cameraHeight = 1000;

  static const double defaultGravity = 980.0;
  static const double defaultJumpSpeed = 350.0;

  static const double defaultCameraFollowSpeed = 8.0;
  static const double defaultCameraLookAhead = 80.0;
  static const double defaultCameraJumpBounce = 24.0;
  static const double defaultCameraBounceDuration = 0.15;

  static const List<Color> defaultGameColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
  ];
}
