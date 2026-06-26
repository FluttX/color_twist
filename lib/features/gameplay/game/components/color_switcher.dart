import 'dart:math' as math;

import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ColorSwitcher extends PositionComponent
    with HasGameReference<TwistColorGame>, CollisionCallbacks {
  ColorSwitcher({
    required super.position,
    this.radius = 20.0,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
        );

  ColorSwitcher.initial() : this(position: Vector2.zero());

  final double radius;
  bool _hitboxAdded = false;

  void prepareForReuse({required Vector2 position}) {
    this.position = position;
  }

  void prepareForPool() {}

  @override
  void onLoad() {
    super.onLoad();
    _ensureHitbox();
  }

  void _ensureHitbox() {
    if (_hitboxAdded) return;
    add(CircleHitbox(
      radius: radius + 6,
      collisionType: CollisionType.passive,
    ));
    _hitboxAdded = true;
  }

  @override
  void render(Canvas canvas) {
    final length = game.gameColors.length;
    final sweep = (math.pi * 2) / length;

    for (int i = 0; i < length; i++) {
      canvas.drawArc(
        size.toRect(),
        i * sweep,
        sweep,
        true,
        Paint()..color = game.gameColors[i],
      );
    }
  }
}
