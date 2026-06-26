import 'dart:math' as math;

import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/game/generation/difficulty_manager.dart';
import 'package:color_twist/features/gameplay/game/generation/difficulty_snapshot.dart';
import 'package:color_twist/features/gameplay/game/generation/obstacle_factory.dart';
import 'package:color_twist/features/gameplay/game/generation/pattern_generator.dart';
import 'package:color_twist/features/gameplay/models/level_object.dart';
import 'package:flame/components.dart';

class InfiniteLevelController {
  InfiniteLevelController({
    required this.world,
    required this.obstacleFactory,
    required this.patternGenerator,
    required this.difficultyManager,
  });

  final World world;
  final ObstacleFactory obstacleFactory;
  final PatternGenerator patternGenerator;
  final DifficultyManager difficultyManager;

  final List<PositionComponent> _activeObstacles = [];

  double _frontierY = 0;
  bool _seeded = false;

  static const _spawnAheadMultiplier = 1.2;
  static const _despawnBehindMultiplier = 0.6;
  static const _initialPatternCount = 3;

  void reset() {
    for (final obstacle in _activeObstacles.toList()) {
      obstacleFactory.release(obstacle);
    }
    _activeObstacles.clear();
    _frontierY = 0;
    _seeded = false;
    patternGenerator.reset();
  }

  void seedInitial(double playerY) {
    reset();

    final switcher = patternGenerator.initialColorSwitcher(playerY);
    _spawnObject(switcher);

    _frontierY = playerY - patternGenerator.frontierBelowSwitcher;
    final difficulty = difficultyManager.snapshotForScore(0);

    for (var i = 0; i < _initialPatternCount; i++) {
      _spawnNextPattern(difficulty, 0);
    }

    _seeded = true;
  }

  void tick(double playerY, int score) {
    if (!_seeded) return;

    final difficulty = difficultyManager.snapshotForScore(score);
    final spawnAhead = GameConstants.cameraHeight * _spawnAheadMultiplier;

    while (_frontierY > playerY - spawnAhead) {
      _spawnNextPattern(difficulty, score);
    }

    _despawnBehind(playerY);
  }

  void _spawnNextPattern(DifficultySnapshot difficulty, int score) {
    final pattern = patternGenerator.next(
      difficulty: difficulty,
      score: score,
    );

    for (final obj in pattern.objects) {
      final worldY = _frontierY + obj.positionY;
      _spawnObject(obj.copyWith(positionY: worldY));
    }

    final circleRadius = pattern.objects
        .where((o) => o.type == LevelObjectType.circleRotator)
        .map((o) => (o.size ?? 180) / 2)
        .fold(0.0, math.max);

    final spacing = patternGenerator.spacingFor(
      difficulty,
      circleRadius > 0 ? circleRadius : 90,
    );
    _frontierY -= pattern.height + spacing;
  }

  void _spawnObject(LevelObject object) {
    final component = obstacleFactory.spawn(object);
    world.add(component);
    _activeObstacles.add(component);
  }

  void unregister(PositionComponent component) {
    _activeObstacles.remove(component);
  }

  void _despawnBehind(double playerY) {
    final despawnLine =
        playerY + GameConstants.cameraHeight * _despawnBehindMultiplier;

    final toRemove = _activeObstacles
        .where((obs) => obs.position.y > despawnLine)
        .toList();

    for (final obstacle in toRemove) {
      obstacleFactory.release(obstacle);
      _activeObstacles.remove(obstacle);
    }
  }
}
