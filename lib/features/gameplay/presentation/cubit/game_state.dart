import 'package:color_twist/core/retention/models/retention_result.dart';
import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  const GameState({
    this.status = GameStatus.playing,
    this.score = 0,
    this.highScore = 0,
    this.isNewHighScore = false,
    this.lastRetentionResult,
  });

  final GameStatus status;
  final int score;
  final int highScore;
  final bool isNewHighScore;
  final RetentionResult? lastRetentionResult;

  GameState copyWith({
    GameStatus? status,
    int? score,
    int? highScore,
    bool? isNewHighScore,
    RetentionResult? lastRetentionResult,
    bool clearRetentionResult = false,
  }) {
    return GameState(
      status: status ?? this.status,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      isNewHighScore: isNewHighScore ?? this.isNewHighScore,
      lastRetentionResult: clearRetentionResult
          ? null
          : (lastRetentionResult ?? this.lastRetentionResult),
    );
  }

  @override
  List<Object?> get props =>
      [status, score, highScore, isNewHighScore, lastRetentionResult];
}
