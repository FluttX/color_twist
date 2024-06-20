import 'package:color_twist/component/ground.dart';
import 'package:color_twist/twist_color_game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent with HasGameRef<TwistColorGame> {
  Player({this.radius = 15.0});

  final _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;

  final double radius;

  @override
  void onMount() {
    position = Vector2.zero();
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;

    /// Get ground ref via key
    Ground ground = gameRef.findByKeyName(Ground.groundKey)!;

    /// Check position of anchor for getting the bottom point of circle.
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
      Paint()..color = Colors.yellow,
    );
  }

  /// [jump] function is use to make jump the player.
  /// It jump y asis using [_jumpSpeed] value.
  /// By default [_jumpSpeed] is 350.0
  void jump() {
    _velocity.y += -_jumpSpeed;
  }
}
