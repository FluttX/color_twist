import 'package:color_twist/features/gameplay/game/components/circle_rotator.dart';
import 'package:color_twist/features/gameplay/game/components/color_switcher.dart';
import 'package:color_twist/features/gameplay/game/components/star_component.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent
    with HasGameReference<TwistColorGame>, CollisionCallbacks {
  Player({
    this.radius = 12.0,
    required super.position,
  }) : super(priority: 20);

  final _velocity = Vector2.zero();

  final double radius;
  Color _color = Colors.white;

  double get _gravity => game.config.gravity;
  double get _jumpSpeed => game.config.jumpSpeed;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox(
      radius: radius,
      anchor: anchor,
      collisionType: CollisionType.active,
    ));
  }

  @override
  void onMount() {
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;

    final ground = game.ground;

    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      _velocity.setValues(0, 0);
      position = Vector2(0, ground.position.y - (height / 2));
    } else {
      _velocity.y += _gravity * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      (size / 2).toOffset(),
      radius,
      Paint()..color = _color,
    );
  }

  void jump() {
    _velocity.y += -_jumpSpeed;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ColorSwitcher) {
      other.removeFromParent();
      _changePlayerColorRandomly();
    } else if (other is CircleArc) {
      if (_color != other.color) {
        game.gameOver();
      }
    } else if (other is StarComponent) {
      other.showCollectEffect();
      game.increaseScore();
      game.audioService.playCollectSound();
    }
  }

  void _changePlayerColorRandomly() {
    _color = game.gameColors.random();
  }
}
