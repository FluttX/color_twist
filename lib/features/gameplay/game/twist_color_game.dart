import 'dart:math';

import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/data/level_loader.dart';
import 'package:color_twist/features/gameplay/data/levels/default_level.dart';
import 'package:color_twist/features/gameplay/game/components/ground.dart';
import 'package:color_twist/features/gameplay/game/components/player.dart';
import 'package:color_twist/features/gameplay/models/game_config.dart';
import 'package:color_twist/features/gameplay/models/level_definition.dart';
import 'package:color_twist/services/audio_service.dart';
import 'package:color_twist/services/haptic_service.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class TwistColorGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  TwistColorGame({
    required this.onScoreChanged,
    required this.onGameOver,
    this.config = const GameConfig(),
    this.level = defaultLevel,
    this.levelLoader = const LevelLoader(),
    AudioService? audioService,
    HapticService? hapticService,
  })  : audioService = audioService ?? AudioService(),
        hapticService = hapticService ?? HapticService(),
        super(
          camera: CameraComponent.withFixedResolution(
            width: GameConstants.cameraWidth,
            height: GameConstants.cameraHeight,
          ),
        );

  final void Function(int score) onScoreChanged;
  final VoidCallback onGameOver;
  final GameConfig config;
  final LevelDefinition level;
  final LevelLoader levelLoader;
  final AudioService audioService;
  final HapticService hapticService;

  late Player player;
  late Ground ground;

  int _score = 0;
  double _shakeDuration = 0;
  double _shakeIntensity = 0;
  final _rnd = Random();

  List<Color> get gameColors => config.gameColors;

  bool get isGamePaused => timeScale == 0.0;

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    decorator = PaintDecorator.blur(0);
    await audioService.initialize();
    await Flame.images.loadAll(AssetPaths.images);
  }

  @override
  void onMount() {
    _initializeGame();
    super.onMount();
  }

  void _initializeGame() {
    _score = 0;
    _shakeDuration = 0;
    _shakeIntensity = 0;
    onScoreChanged(_score);

    ground = Ground(position: Vector2(0, level.groundY));
    world.add(ground);
    world.add(player = Player(position: Vector2(0, level.playerY)));

    camera.moveTo(Vector2(0, 0));

    levelLoader.loadInto(world, level);

    audioService.playBackgroundMusic();
  }

  void shakeScreen({double intensity = 4.0, double duration = 0.15}) {
    _shakeIntensity = intensity;
    _shakeDuration = duration;
  }

  @override
  void update(double dt) {
    var cameraY = camera.viewfinder.position.y;
    final playerY = player.position.y;
    if (playerY < cameraY) {
      cameraY = playerY;
    }

    if (_shakeDuration > 0) {
      _shakeDuration -= dt;
      final offsetX = (_rnd.nextDouble() - 0.5) * 2 * _shakeIntensity;
      final offsetY = (_rnd.nextDouble() - 0.5) * 2 * _shakeIntensity;
      camera.viewfinder.position = Vector2(offsetX, cameraY + offsetY);
    } else {
      camera.viewfinder.position = Vector2(0, cameraY);
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    hapticService.onJump();
    super.onTapDown(event);
  }

  void gameOver() {
    hapticService.onGameOver();
    audioService.stopBackgroundMusic();
    for (final element in world.children) {
      element.removeFromParent();
    }
    onGameOver();
  }

  void playAgain() {
    _initializeGame();
  }

  void pauseGame() {
    audioService.pauseBackgroundMusic();
    (decorator as PaintDecorator).addBlur(10);
    timeScale = 0.0;
  }

  void resumeGame() {
    audioService.resumeBackgroundMusic();
    (decorator as PaintDecorator).addBlur(0);
    timeScale = 1.0;
  }

  void increaseScore() {
    _score++;
    onScoreChanged(_score);
  }
}
