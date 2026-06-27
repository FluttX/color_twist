import 'dart:math' as math;

import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/game/generation/difficulty_manager.dart';
import 'package:color_twist/features/gameplay/game/generation/difficulty_snapshot.dart';
import 'package:color_twist/features/gameplay/game/generation/obstacle_factory.dart';
import 'package:color_twist/features/gameplay/game/generation/pattern_generator.dart';
import 'package:color_twist/features/gameplay/game/components/star_component.dart';
import 'package:color_twist/features/gameplay/models/level_object.dart';
import 'package:flame/components.dart';

class InfiniteLevelController {
  InfiniteLevelController({
    required this.world,
    required this.obstacleFactory,
    required this.patternGenerator,
    required this.difficultyManager,
    this.onStarMissed,
  });

  final World world;
  final ObstacleFactory obstacleFactory;
  final PatternGenerator patternGenerator;
  final DifficultyManager difficultyManager;
  final void Function()? onStarMissed;

  final List<PositionComponent> _activeObstacles = [];

  double _frontierY = 0;
  bool _seeded = false;

  /// How far above the visible top edge to place the next pattern.
  static const _spawnAboveViewport = 180.0;
  static const _despawnBelowViewport = 0.5;
  static const _maxPatternsPerTick = 2;

  static double cameraTopY(double cameraY) =>
      cameraY - GameConstants.cameraHeight / 2;

  void reset() {
    for (final obstacle in _activeObstacles.toList()) {
      obstacleFactory.release(obstacle);
    }
    _activeObstacles.clear();
    _frontierY = 0;
    _seeded = false;
    patternGenerator.reset();
  }

  void seedInitial(double playerY, double cameraY) {
    reset();

    final switcher = patternGenerator.initialColorSwitcher(playerY);
    _spawnObject(switcher);

    _frontierY = playerY - patternGenerator.frontierBelowSwitcher;
    final difficulty = difficultyManager.snapshotForScore(0);
    _fillViewportTop(cameraY, difficulty, 0);

    _seeded = true;
  }

  void tick(double playerY, double cameraY, int score) {
    if (!_seeded) return;

    final difficulty = difficultyManager.snapshotForScore(score);
    _fillViewportTop(cameraY, difficulty, score);
    _despawnBehind(playerY);
  }

  void _fillViewportTop(
    double cameraY,
    DifficultySnapshot difficulty,
    int score,
  ) {
    final spawnLine = cameraTopY(cameraY) - _spawnAboveViewport;
    var spawned = 0;

    while (_frontierY > spawnLine && spawned < _maxPatternsPerTick) {
      _spawnNextPattern(difficulty, score);
      spawned++;
    }
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
        playerY + GameConstants.cameraHeight * _despawnBelowViewport;

    final toRemove = _activeObstacles
        .where((obs) => obs.position.y > despawnLine)
        .toList();

    for (final obstacle in toRemove) {
      if (obstacle is StarComponent && !obstacle.isCollected) {
        onStarMissed?.call();
      }
      obstacleFactory.release(obstacle);
      _activeObstacles.remove(obstacle);
    }
  }
}
