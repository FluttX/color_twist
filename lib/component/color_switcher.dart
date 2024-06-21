import 'dart:math' as math;

import 'package:color_twist/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColorSwitcher extends PositionComponent
    with HasGameRef<TwistColorGame>, CollisionCallbacks {
  ColorSwitcher({
    required super.position,
    this.radius = 20.0,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
        );

  final double radius;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      anchor: anchor,
      position: size / 2,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
    final length = gameRef.gameColors.length;
    final sweep = (math.pi * 2) / length;

    for (int i = 0; i < length; i++) {
      canvas.drawArc(
        size.toRect(),
        i * sweep,
        sweep,
        true,
        Paint()..color = gameRef.gameColors[i],
      );
    }
  }
}
