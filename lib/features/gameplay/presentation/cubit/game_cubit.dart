import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(const GameState()) {
    _game = TwistColorGame(
      onScoreChanged: _onScoreChanged,
      onGameOver: _onGameOver,
    );
  }

  late final TwistColorGame _game;

  TwistColorGame get game => _game;

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
    emit(const GameState());
  }

  void _onScoreChanged(int score) {
    emit(state.copyWith(score: score));
  }

  void _onGameOver() {
    emit(state.copyWith(status: GameStatus.gameOver));
  }
}
