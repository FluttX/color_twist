import 'package:color_twist/component/circle_rotator.dart';
import 'package:color_twist/component/color_switcher.dart';
import 'package:color_twist/component/ground.dart';
import 'package:color_twist/component/star_component.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'component/player.dart';

class TwistColorGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player player;

  ValueNotifier<bool> isGameOver = ValueNotifier(false);
  ValueNotifier<int> currentScore = ValueNotifier(0);
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
  Future<void> onLoad() async {
    await super.onLoad();
    decorator = PaintDecorator.blur(0);
    FlameAudio.bgm.initialize();
    await Flame.images.loadAll(['star_icon.png', 'finger_tap.png']);
    await FlameAudio.audioCache.loadAll(['background.mp3', 'collect.wav']);
  }

  @override
  void onMount() {
    _initializeGame();
    super.onMount();
  }

  _initializeGame() {
    isGameOver.value = false;

    world.add(Ground(position: Vector2(0, 400)));
    world.add(player = Player(position: Vector2(0, 300)));

    camera.moveTo(Vector2(0, 0));

    _generateGameComponents();

    FlameAudio.bgm.play('background.mp3');
  }

  void _generateGameComponents() {
    world.add(ColorSwitcher(position: Vector2(0, 180)));
    world.add(StarComponent(position: Vector2(0, 0)));
    world.add(
      CircleRotator(position: Vector2(0, 0), size: Vector2(200, 200)),
    );

    world.add(ColorSwitcher(position: Vector2(0, -200)));
    world.add(StarComponent(position: Vector2(0, -400)));
    world.add(
      CircleRotator(position: Vector2(0, -400), size: Vector2(150, 150)),
    );
    world.add(
      CircleRotator(position: Vector2(0, -400), size: Vector2(180, 180)),
    );
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

  void gameOver() {
    FlameAudio.bgm.stop();
    for (var element in world.children) {
      element.removeFromParent();
    }
    isGameOver.value = true;
  }

  bool get isGamePaused => timeScale == 0.0;
  bool get isGamePlaying => !isGamePaused;

  void playAgain() {
    currentScore.value = 0;
    _initializeGame();
  }

  void pauseGame() {
    FlameAudio.bgm.pause();
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
  }

  void resumeGame() {
    FlameAudio.bgm.resume();
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
  }

  void increaseScore() {
    currentScore.value++;
  }
}
