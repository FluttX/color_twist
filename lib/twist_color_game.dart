import 'package:color_twist/component/circle_rotator.dart';
import 'package:color_twist/component/ground.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'component/player.dart';

class TwistColorGame extends FlameGame with TapCallbacks {
  late Player player;

  final List<Color> gameColors;

  TwistColorGame({
    this.gameColors = const [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
    ],
  }) : super(
          camera: CameraComponent.withFixedResolution(
            width: 600,
            height: 1000,
          ),
        );

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void onMount() {
    /// Ground line
    world.add(Ground(position: Vector2(0, 400)));

    /// Player component
    world.add(player = Player(position: Vector2(0, 300)));

    /// Generating arc circle with different color and sweep
    generateGameComponents();
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

  void generateGameComponents() {
    world.add(
      CircleRotator(position: Vector2(0, 100), size: Vector2(200, 200)),
    );
  }
}
