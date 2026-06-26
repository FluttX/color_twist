import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.playing,
    this.score = 0,
  });

  final GameStatus status;
  final int score;

  GameState copyWith({
    GameStatus? status,
    int? score,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [status, score];
}
