import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/game/generation/difficulty_snapshot.dart';

class DifficultyManager {
  const DifficultyManager();

  static const _maxScore = 150.0;
  static const _flatSpeedUntilScore = 30;

  DifficultySnapshot snapshotForScore(int score) {
    final t = (score / _maxScore).clamp(0.0, 1.0);
    final rotationSpeed = score < _flatSpeedUntilScore
        ? 1.2
        : _lerp(
            1.2,
            3.0,
            ((score - _flatSpeedUntilScore) /
                    (_maxScore - _flatSpeedUntilScore))
                .clamp(0.0, 1.0),
          );

    return DifficultySnapshot(
      rotationSpeed: rotationSpeed,
      minSpacing: _lerp(240.0, 140.0, t),
      maxSpacing: _lerp(300.0, 200.0, t),
      starWeight: _lerp(0.35, 0.15, t),
      switcherWeight: _lerp(0.25, 0.10, t),
      singleCircleWeight: _lerp(0.40, 0.30, t),
      doubleCircleWeight: _lerp(0.0, 0.20, t),
      specialPatternWeight: _lerp(0.0, 0.15, t),
      horizontalMoveChance: _lerp(0.0, 0.30, t),
      verticalMoveChance: _lerp(0.0, 0.18, t),
      moveAmplitude: _lerp(0.0, 30.0, t),
      moveSpeed: _lerp(0.0, 1.2, t),
      gravity: _lerp(720.0, GameConstants.defaultGravity, t),
      jumpSpeed: _lerp(300.0, 330.0, t),
    );
  }

  double _lerp(double start, double end, double t) => start + (end - start) * t;
}
