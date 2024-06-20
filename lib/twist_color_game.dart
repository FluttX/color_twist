import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class TwistColorGame extends FlameGame with TapCallbacks {
  late Player player;

  TwistColorGame()
      : super(
          camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
        );

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void onMount() {
    world.add(player = Player());

    world.add(RectangleComponent(
        position: Vector2(-100, 100), size: Vector2.all(20)));

    world.add(
        RectangleComponent(position: Vector2(100, 25), size: Vector2.all(20)));

    world.add(
        RectangleComponent(position: Vector2(220, 225), size: Vector2.all(20)));
    super.onMount();
  }

  @override
  void update(double dt) {
    final cameraY = camera.viewfinder.position.y;
    final playerY = player.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(0, playerY);
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    super.onTapDown(event);
  }
}
