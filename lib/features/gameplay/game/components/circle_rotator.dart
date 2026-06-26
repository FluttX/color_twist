import 'dart:math' as math;

import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class CircleRotator extends PositionComponent
    with HasGameReference<TwistColorGame> {
  CircleRotator({
    required super.position,
    required super.size,
    this.thickness = 8.0,
    this.rotationSpeed = 1.2,
    this.initialAngle = 0,
    this.moveAmplitudeX = 0,
    this.moveAmplitudeY = 0,
    this.moveSpeed = 0,
  })  : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  CircleRotator.initial()
      : this(
          position: Vector2.zero(),
          size: Vector2.all(180),
        );

  final double thickness;
  double rotationSpeed;
  double initialAngle;
  double moveAmplitudeX;
  double moveAmplitudeY;
  double moveSpeed;

  bool _passed = false;
  bool _arcsBuilt = false;
  double _builtSize = 0;

  bool get hasPassed => _passed;

  void markPassed() {
    _passed = true;
  }

  void prepareForReuse({
    required Vector2 position,
    required Vector2 size,
    required double rotationSpeed,
    required double initialAngle,
    required double moveAmplitudeX,
    required double moveAmplitudeY,
    required double moveSpeed,
  }) {
    _passed = false;
    this.position = position;
    this.size = size;
    this.rotationSpeed = rotationSpeed;
    this.initialAngle = initialAngle;
    this.moveAmplitudeX = moveAmplitudeX;
    this.moveAmplitudeY = moveAmplitudeY;
    this.moveSpeed = moveSpeed;
    angle = initialAngle;
    scale = Vector2.all(1);

    if (_arcsBuilt && _builtSize != size.x) {
      for (final child in children.whereType<CircleArc>().toList()) {
        child.removeFromParent();
      }
      _arcsBuilt = false;
    }
  }

  void prepareForPool() {
    _removeEffects();
    _passed = false;
  }

  @override
  void onMount() {
    super.onMount();

    if (!_arcsBuilt) {
      _buildArcs();
    }

    _removeEffects();
    _applyEffects();
  }

  void _buildArcs() {
    final length = game.gameColors.length;
    const circle = math.pi * 2;
    final sweep = circle / length;

    for (int i = 0; i < length; i++) {
      add(
        CircleArc(
          color: game.gameColors[i],
          startAngle: i * sweep,
          sweepAngle: sweep,
        ),
      );
    }

    _arcsBuilt = true;
    _builtSize = size.x;
  }

  void _applyEffects() {
    final rotationDuration = (math.pi * 2) / rotationSpeed;

    add(
      RotateEffect.by(
        math.pi * 2,
        EffectController(
          duration: rotationDuration,
          infinite: true,
        ),
      ),
    );

    if (moveAmplitudeX > 0 && moveSpeed > 0) {
      add(
        MoveByEffect(
          Vector2(moveAmplitudeX, 0),
          EffectController(
            duration: 1 / moveSpeed,
            alternate: true,
            infinite: true,
          ),
        ),
      );
    }

    if (moveAmplitudeY > 0 && moveSpeed > 0) {
      add(
        MoveByEffect(
          Vector2(0, moveAmplitudeY),
          EffectController(
            duration: 1 / moveSpeed,
            alternate: true,
            infinite: true,
          ),
        ),
      );
    }
  }

  void _removeEffects() {
    for (final effect in children.whereType<Effect>().toList()) {
      effect.removeFromParent();
    }
  }
}

class CircleArc extends PositionComponent with ParentIsA<CircleRotator> {
  CircleArc({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
  }) : super(anchor: Anchor.center);

  final Color color;
  final double startAngle, sweepAngle;

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;
    _addHitBox();
    super.onMount();
  }

  void _addHitBox() {
    final center = size / 2;
    const precision = 8;

    final segment = sweepAngle / (precision - 1);
    final radius = size.x / 2;

    List<Vector2> vertices = [];

    for (int i = 0; i < precision; i++) {
      final thisSegment = startAngle + segment * i;
      vertices.add(
        center + Vector2(math.cos(thisSegment), math.sin(thisSegment)) * radius,
      );
    }

    for (int i = precision - 1; i >= 0; i--) {
      final thisSegment = startAngle + segment * i;
      vertices.add(
        center +
            Vector2(math.cos(thisSegment), math.sin(thisSegment)) *
                (radius - parent.thickness),
      );
    }

    add(PolygonHitbox(vertices, collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
      size.toRect().deflate(parent.thickness / 2),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = parent.thickness,
    );
  }
}
