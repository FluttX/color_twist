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

  double _cameraTargetY = 0;
  double _cameraCurrentY = 0;
  double _bounceElapsed = 0;

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
    _cameraTargetY = 0;
    _cameraCurrentY = 0;
    _bounceElapsed = config.cameraBounceDuration;
    onScoreChanged(_score);

    ground = Ground(position: Vector2(0, level.groundY));
    world.add(ground);
    world.add(player = Player(position: Vector2(0, level.playerY)));

    camera.viewfinder.position = Vector2.zero();

    levelLoader.loadInto(world, level);

    audioService.playBackgroundMusic();
  }

  void shakeScreen({double intensity = 4.0, double duration = 0.15}) {
    _shakeIntensity = intensity;
    _shakeDuration = duration;
  }

  void _triggerCameraBounce() {
    _bounceElapsed = 0;
  }

  void _updateCamera(double dt) {
    final desiredY = player.position.y - config.cameraLookAhead;
    if (desiredY < _cameraTargetY) {
      _cameraTargetY = desiredY;
    }

    var bounceY = 0.0;
    if (_bounceElapsed < config.cameraBounceDuration) {
      final progress =
          (_bounceElapsed / config.cameraBounceDuration).clamp(0.0, 1.0);
      bounceY = -config.cameraJumpBounce * sin(progress * pi);
      _bounceElapsed += dt;
    }

    final goalY = _cameraTargetY + bounceY;
    final t = 1 - exp(-config.cameraFollowSpeed * dt);
    _cameraCurrentY += (goalY - _cameraCurrentY) * t;

    var shakeX = 0.0;
    var shakeY = 0.0;
    if (_shakeDuration > 0) {
      _shakeDuration -= dt;
      shakeX = (_rnd.nextDouble() - 0.5) * 2 * _shakeIntensity;
      shakeY = (_rnd.nextDouble() - 0.5) * 2 * _shakeIntensity;
    }

    camera.viewfinder.position = Vector2(shakeX, _cameraCurrentY + shakeY);
  }

  @override
  void update(double dt) {
    _updateCamera(dt);
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.jump();
    hapticService.onJump();
    _triggerCameraBounce();
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
