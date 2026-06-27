import 'package:color_twist/core/retention/models/run_stats.dart';
import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:color_twist/core/services/score_service.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:color_twist/features/gameplay/models/game_config.dart';
import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:color_twist/features/store/services/store_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit._({
    required ScoreService scoreService,
    required RetentionEngine retentionEngine,
    required GameConfig config,
    required String musicTrackPath,
  })  : _scoreService = scoreService,
        _retentionEngine = retentionEngine,
        super(const GameState()) {
    _game = TwistColorGame(
      onScoreChanged: _onScoreChanged,
      onGameOver: _onGameOver,
      scoreService: _scoreService,
      config: config,
      musicTrackPath: musicTrackPath,
    );
    _loadHighScore();
  }

  static Future<GameCubit> create({
    required ScoreService scoreService,
    required RetentionEngine retentionEngine,
    required StoreService storeService,
  }) async {
    await storeService.initialize();
    final appearance = await storeService.loadAppearance();
    final theme = await storeService.loadTheme();
    final musicTrackPath = await storeService.loadMusicTrackPath();
    final config = GameConfig(
      gameColors: theme.gameColors,
      appearance: appearance,
      theme: theme,
    );
    return GameCubit._(
      scoreService: scoreService,
      retentionEngine: retentionEngine,
      config: config,
      musicTrackPath: musicTrackPath,
    );
  }

  final ScoreService _scoreService;
  final RetentionEngine _retentionEngine;
  late final TwistColorGame _game;

  TwistColorGame get game => _game;

  Future<void> _loadHighScore() async {
    await _scoreService.initialize();
    emit(state.copyWith(highScore: _scoreService.highScore));
  }

  void pause() {
    _game.pauseGame();
    emit(state.copyWith(status: GameStatus.paused));
  }

  void resume() {
    _game.resumeGame();
    emit(state.copyWith(status: GameStatus.playing));
  }

  void playAgain() {
    _game.playAgain();
    emit(GameState(highScore: _scoreService.highScore));
  }

  void _onScoreChanged(int score) {
    emit(state.copyWith(score: score));
  }

  Future<void> _onGameOver(
    RunStats stats, {
    required bool isNewHighScore,
  }) async {
    final retentionResult = await _retentionEngine.processRun(stats);
    emit(
      state.copyWith(
        status: GameStatus.gameOver,
        score: stats.score,
        highScore: _scoreService.highScore,
        isNewHighScore: isNewHighScore,
        lastRetentionResult: retentionResult,
      ),
    );
  }
}
