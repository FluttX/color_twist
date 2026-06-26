import 'dart:math' as math;

import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:color_twist/features/gameplay/game/components/player.dart';
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
          priority: 10,
        );

  ColorSwitcher.initial() : this(position: Vector2.zero());

  final double radius;
  bool _hitboxAdded = false;
  bool _collected = false;

  bool get isCollected => _collected;

  void prepareForReuse({required Vector2 position}) {
    this.position = Vector2(0, position.y);
    _collected = false;
  }

  void prepareForPool() {
    _collected = false;
  }

  void markCollected() {
    _collected = true;
  }

  @override
  void onLoad() {
    super.onLoad();
    _ensureHitbox();
  }

  void _ensureHitbox() {
    if (_hitboxAdded) return;
    add(CircleHitbox(
      radius: radius + 12,
      collisionType: CollisionType.passive,
    ));
    _hitboxAdded = true;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_collected || !isMounted) return;
    if (!_isPlayer(other)) return;
    game.collectColorSwitcher(this);
  }

  bool _isPlayer(PositionComponent other) {
    if (other is Player) return true;
    return other.parent is Player;
  }

  @override
  void render(Canvas canvas) {
    final center = (size / 2).toOffset();
    final length = game.gameColors.length;
    final sweep = (math.pi * 2) / length;

    canvas.drawCircle(
      center,
      radius + 8,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    for (int i = 0; i < length; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep,
        sweep,
        true,
        Paint()..color = game.gameColors[i],
      );
    }
  }
}
