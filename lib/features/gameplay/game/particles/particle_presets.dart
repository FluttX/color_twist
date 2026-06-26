import 'package:flutter/material.dart';

class ParticlePreset {
  const ParticlePreset({
    required this.count,
    required this.lifespan,
    this.speedMagnitude = 80,
    this.accelerationMagnitude = 40,
    this.priority = 100,
  });

  final int count;
  final double lifespan;
  final double speedMagnitude;
  final double accelerationMagnitude;
  final int priority;
}

abstract final class ParticlePresets {
  static const starCollect = ParticlePreset(
    count: 28,
    lifespan: 0.8,
    speedMagnitude: 80,
    accelerationMagnitude: 40,
    priority: 50,
  );

  static const colorSwitch = ParticlePreset(
    count: 20,
    lifespan: 0.6,
    speedMagnitude: 70,
    accelerationMagnitude: 30,
    priority: 50,
  );

  static const gameOverExplosion = ParticlePreset(
    count: 45,
    lifespan: 0.7,
    speedMagnitude: 120,
    accelerationMagnitude: 60,
    priority: 200,
  );

  static const perfectCombo = ParticlePreset(
    count: 30,
    lifespan: 0.9,
    speedMagnitude: 90,
    accelerationMagnitude: 20,
    priority: 60,
  );

  static const newHighScore = ParticlePreset(
    count: 70,
    lifespan: 1.4,
    speedMagnitude: 100,
    accelerationMagnitude: 80,
    priority: 250,
  );

  static const trailDrip = ParticlePreset(
    count: 2,
    lifespan: 0.25,
    speedMagnitude: 30,
    accelerationMagnitude: 60,
    priority: 10,
  );

  static const comboColors = [
    Color(0xFFFFD700),
    Color(0xFFFFA500),
    Color(0xFFFFE066),
    Color(0xFFFFF8DC),
  ];

  static const confettiColors = [
    Color(0xFFFFD700),
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF96CEB4),
    Color(0xFFFFEAA7),
    Color(0xFFDDA0DD),
  ];
}
