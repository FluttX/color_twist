import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/data/level_loader.dart';
import 'package:color_twist/features/gameplay/data/levels/default_level.dart';
import 'package:color_twist/features/gameplay/game/components/ground.dart';
import 'package:color_twist/features/gameplay/game/components/player.dart';
import 'package:color_twist/features/gameplay/models/game_config.dart';
import 'package:color_twist/features/gameplay/models/level_definition.dart';
import 'package:color_twist/services/audio_service.dart';
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
  })  : audioService = audioService ?? AudioService(),
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

  late Player player;
  late Ground ground;

  int _score = 0;

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
    onScoreChanged(_score);

    ground = Ground(position: Vector2(0, level.groundY));
    world.add(ground);
    world.add(player = Player(position: Vector2(0, level.playerY)));

    camera.moveTo(Vector2(0, 0));

    levelLoader.loadInto(world, level);

    audioService.playBackgroundMusic();
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
