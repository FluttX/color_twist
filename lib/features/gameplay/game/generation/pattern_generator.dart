import 'dart:math' as math;

import 'package:color_twist/features/gameplay/game/generation/difficulty_snapshot.dart';
import 'package:color_twist/features/gameplay/game/generation/obstacle_pattern.dart';
import 'package:color_twist/features/gameplay/models/level_object.dart';

class PatternGenerator {
  PatternGenerator({
    math.Random? random,
    this.colorCount = 4,
  }) : _random = random ?? math.Random();

  final math.Random _random;
  final int colorCount;
  final List<PatternId> _recentPatterns = [];

  static const _noRepeatCapacity = 5;
  static const _circleSizes = [150.0, 180.0, 200.0];
  static const _switcherRadius = 20.0;
  static const _switcherToCircleGap = 120.0;
  static const _circleStackGap = 80.0;
  static const _initialSwitcherOffset = 100.0;
  static const _frontierBelowSwitcher = 200.0;

  int _expectedColorIndex = 0;

  double get initialSwitcherOffset => _initialSwitcherOffset;

  double get frontierBelowSwitcher => _frontierBelowSwitcher;

  static const _catalog = <ObstaclePattern>[
    ObstaclePattern(
      id: PatternId.switcherCircle,
      minScore: 0,
      height: 280,
      objects: [
        LevelObject(
          type: LevelObjectType.colorSwitcher,
          positionX: 0,
          positionY: -50,
        ),
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -260,
          size: 180,
        ),
      ],
    ),
    ObstaclePattern(
      id: PatternId.starCircle,
      minScore: 0,
      height: 230,
      objects: [
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -130,
          size: 200,
        ),
        LevelObject(
          type: LevelObjectType.star,
          positionX: 0,
          positionY: -130,
        ),
      ],
    ),
    ObstaclePattern(
      id: PatternId.circleStar,
      minScore: 0,
      height: 280,
      objects: [
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -130,
          size: 180,
        ),
        LevelObject(
          type: LevelObjectType.star,
          positionX: 0,
          positionY: -280,
        ),
      ],
    ),
    ObstaclePattern(
      id: PatternId.doubleCircle,
      minScore: 15,
      height: 280,
      objects: [
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -140,
          size: 200,
        ),
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -280,
          size: 150,
        ),
      ],
    ),
    ObstaclePattern(
      id: PatternId.switcherDoubleCircle,
      minScore: 30,
      height: 520,
      objects: [
        LevelObject(
          type: LevelObjectType.colorSwitcher,
          positionX: 0,
          positionY: -50,
        ),
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -260,
          size: 180,
        ),
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -505,
          size: 150,
        ),
      ],
    ),
    ObstaclePattern(
      id: PatternId.movingCircle,
      minScore: 20,
      height: 200,
      objects: [
        LevelObject(
          type: LevelObjectType.circleRotator,
          positionX: 0,
          positionY: -200,
          size: 180,
        ),
      ],
    ),
  ];

  void reset() {
    _recentPatterns.clear();
    _expectedColorIndex = 0;
  }

  ObstaclePattern next({
    required DifficultySnapshot difficulty,
    required int score,
  }) {
    final template = _pickPattern(difficulty, score);
    _recordPattern(template.id);
    return _buildPattern(template, difficulty);
  }

  LevelObject initialColorSwitcher(double playerY) {
    return LevelObject(
      type: LevelObjectType.colorSwitcher,
      positionX: 0,
      positionY: playerY - _initialSwitcherOffset,
    );
  }

  ObstaclePattern _pickPattern(DifficultySnapshot difficulty, int score) {
    final eligible = _catalog.where((p) => p.minScore <= score).toList();

    for (var attempt = 0; attempt < 3; attempt++) {
      final picked = _weightedPick(eligible, difficulty, score);
      if (!_recentPatterns.contains(picked.id)) {
        return picked;
      }
    }

    return eligible.firstWhere(
      (p) => p.id == PatternId.switcherCircle,
      orElse: () => eligible.first,
    );
  }

  ObstaclePattern _weightedPick(
    List<ObstaclePattern> eligible,
    DifficultySnapshot difficulty,
    int score,
  ) {
    final weights = <PatternId, double>{};
    for (final pattern in eligible) {
      weights[pattern.id] = _weightFor(pattern.id, difficulty, score);
    }

    final total = weights.values.fold(0.0, (sum, w) => sum + w);
    if (total <= 0) {
      return eligible.first;
    }

    var roll = _random.nextDouble() * total;
    for (final pattern in eligible) {
      roll -= weights[pattern.id] ?? 0;
      if (roll <= 0) {
        return pattern;
      }
    }
    return eligible.last;
  }

  double _weightFor(
    PatternId id,
    DifficultySnapshot difficulty,
    int score,
  ) {
    return switch (id) {
      PatternId.switcherCircle =>
        difficulty.switcherWeight + difficulty.singleCircleWeight,
      PatternId.starCircle =>
        difficulty.starWeight + difficulty.singleCircleWeight * 0.5,
      PatternId.circleStar =>
        difficulty.starWeight + difficulty.singleCircleWeight * 0.5,
      PatternId.doubleCircle => difficulty.doubleCircleWeight,
      PatternId.switcherDoubleCircle =>
        difficulty.doubleCircleWeight + difficulty.specialPatternWeight,
      PatternId.movingCircle =>
        difficulty.specialPatternWeight + (score >= 20 ? 0.15 : 0),
    };
  }

  void _recordPattern(PatternId id) {
    _recentPatterns.add(id);
    while (_recentPatterns.length > _noRepeatCapacity) {
      _recentPatterns.removeAt(0);
    }
  }

  ObstaclePattern _buildPattern(
    ObstaclePattern template,
    DifficultySnapshot difficulty,
  ) {
    final objects = <LevelObject>[];
    LevelObject? lastCircle;

    for (final obj in template.objects) {
      switch (obj.type) {
        case LevelObjectType.colorSwitcher:
          objects.add(obj);
          _expectedColorIndex = _random.nextInt(colorCount);
        case LevelObjectType.star:
          objects.add(obj);
        case LevelObjectType.circleRotator:
          final circle = _configureCircle(obj, template.id, difficulty);
          objects.add(circle);
          lastCircle = circle;
      }
    }

    if (template.id == PatternId.starCircle && lastCircle != null) {
      for (var i = 0; i < objects.length; i++) {
        if (objects[i].type == LevelObjectType.star) {
          objects[i] = objects[i].copyWith(
            positionX: lastCircle.positionX,
            positionY: lastCircle.positionY,
          );
        }
      }
    }

    if (template.id == PatternId.switcherCircle ||
        template.id == PatternId.switcherDoubleCircle) {
      _layoutSwitcherPattern(objects);
    }

    final height = _patternHeight(objects, template.height);

    return ObstaclePattern(
      id: template.id,
      objects: objects,
      height: height,
      minScore: template.minScore,
    );
  }

  double _patternHeight(List<LevelObject> objects, double fallback) {
    if (objects.isEmpty) return fallback;

    var minY = 0.0;
    for (final obj in objects) {
      minY = math.min(minY, obj.positionY);
      if (obj.type == LevelObjectType.circleRotator) {
        final radius = (obj.size ?? 180) / 2;
        minY = math.min(minY, obj.positionY - radius);
      }
    }

    return math.max(fallback, -minY + 20);
  }

  void _layoutSwitcherPattern(List<LevelObject> objects) {
    final switcherIndex =
        objects.indexWhere((o) => o.type == LevelObjectType.colorSwitcher);
    if (switcherIndex == -1) return;

    const switcherY = -50.0;
    objects[switcherIndex] =
        objects[switcherIndex].copyWith(positionY: switcherY);

    final circleIndices = <int>[];
    for (var i = 0; i < objects.length; i++) {
      if (objects[i].type == LevelObjectType.circleRotator) {
        circleIndices.add(i);
      }
    }

    if (circleIndices.isEmpty) return;

    var prevRadius = 0.0;
    var circleCenterY = 0.0;

    for (var i = 0; i < circleIndices.length; i++) {
      final index = circleIndices[i];
      final circle = objects[index];
      final radius = (circle.size ?? 180) / 2;

      if (i == 0) {
        circleCenterY =
            switcherY - _switcherRadius - _switcherToCircleGap - radius;
      } else {
        circleCenterY =
            circleCenterY - prevRadius - _circleStackGap - radius;
      }

      objects[index] = circle.copyWith(positionY: circleCenterY);
      prevRadius = radius;
    }
  }

  LevelObject _configureCircle(
    LevelObject obj,
    PatternId patternId,
    DifficultySnapshot difficulty,
  ) {
    final keepFixedSize = patternId == PatternId.starCircle;
    final size = keepFixedSize
        ? (obj.size ?? 200)
        : _pickCircleSize(obj.size ?? 180);
    final rotationSpeed = difficulty.rotationSpeed;
    final initialAngle = _entryAngleForColor(_expectedColorIndex);

    double? moveAmplitudeX;
    double? moveAmplitudeY;
    double? moveSpeed;

    final allowMovement = patternId != PatternId.starCircle &&
        patternId != PatternId.switcherCircle &&
        patternId != PatternId.switcherDoubleCircle;
    final shouldMove = allowMovement &&
        (patternId == PatternId.movingCircle ||
            _random.nextDouble() <
                difficulty.horizontalMoveChance +
                    difficulty.verticalMoveChance);

    if (shouldMove && difficulty.moveAmplitude > 0) {
      if (patternId == PatternId.movingCircle ||
          _random.nextDouble() < difficulty.horizontalMoveChance) {
        moveAmplitudeX = difficulty.moveAmplitude;
      }
      if (patternId == PatternId.movingCircle ||
          _random.nextDouble() < difficulty.verticalMoveChance) {
        moveAmplitudeY = difficulty.moveAmplitude * 0.5;
      }
      moveSpeed = difficulty.moveSpeed > 0 ? difficulty.moveSpeed : 1.5;
    }

    return obj.copyWith(
      size: size,
      rotationSpeed: rotationSpeed,
      initialAngle: initialAngle,
      moveAmplitudeX: moveAmplitudeX,
      moveAmplitudeY: moveAmplitudeY,
      moveSpeed: moveSpeed,
    );
  }

  double _pickCircleSize(double fallback) {
    if (_random.nextBool()) {
      return _circleSizes[_random.nextInt(_circleSizes.length)];
    }
    return fallback;
  }

  double _entryAngleForColor(int colorIndex) {
    final sweep = (math.pi * 2) / colorCount;
    final arcCenter = colorIndex * sweep + sweep / 2;
    const entryAngle = math.pi / 2;
    return entryAngle - arcCenter;
  }

  double spacingFor(DifficultySnapshot difficulty, double circleRadius) {
    final minGap = circleRadius + 80;
    final spacing = difficulty.minSpacing +
        _random.nextDouble() * (difficulty.maxSpacing - difficulty.minSpacing);
    return math.max(spacing, minGap);
  }
}
