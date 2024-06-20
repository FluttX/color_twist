import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Player extends PositionComponent {
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
    _velocity.y += _gravity * dt;
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

  void jump() {
    _velocity.y += -_jumpSpeed;
  }
}
