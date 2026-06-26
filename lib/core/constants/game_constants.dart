import 'package:flutter/material.dart';

abstract final class GameConstants {
  static const double cameraWidth = 600;
  static const double cameraHeight = 1000;

  static const double defaultGravity = 980.0;
  static const double defaultJumpSpeed = 350.0;

  static const List<Color> defaultGameColors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
  ];
}
