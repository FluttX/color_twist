import 'package:color_twist/component/ground.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'component/player.dart';

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
    world.add(Ground(position: Vector2(0, 400)));
    world.add(player = Player());
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
