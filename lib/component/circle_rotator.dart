import 'dart:math' as math;

import 'package:color_twist/twist_color_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class CircleRotator extends PositionComponent with HasGameRef<TwistColorGame> {
  CircleRotator({
    required super.position,
    required super.size,
    this.thickness = 8.0,
    this.rotationSpeed = 2.0,
  })  : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  final double thickness;
  final double rotationSpeed;

  @override
  void onLoad() {
    super.onLoad();

    const circle = math.pi * 2;
    final sweep = circle / gameRef.gameColors.length;

    for (int i = 0; i < gameRef.gameColors.length; i++) {
      add(
        CircleArc(
          color: gameRef.gameColors[i],
          startAngle: i * sweep,
          sweepAngle: sweep,
        ),
      );
    }

    add(
      RotateEffect.to(
        circle,
        EffectController(speed: rotationSpeed, infinite: true),
      ),
    );
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
    super.onMount();
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
