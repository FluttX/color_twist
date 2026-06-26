import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/game/generation/difficulty_snapshot.dart';

class DifficultyManager {
  const DifficultyManager();

  static const _maxScore = 180.0;
  static const _flatSpeedUntilScore = 45;

  DifficultySnapshot snapshotForScore(int score) {
    final t = (score / _maxScore).clamp(0.0, 1.0);
    final rotationSpeed = score < _flatSpeedUntilScore
        ? 1.0
        : _lerp(
            1.0,
            2.6,
            ((score - _flatSpeedUntilScore) /
                    (_maxScore - _flatSpeedUntilScore))
                .clamp(0.0, 1.0),
          );

    return DifficultySnapshot(
      rotationSpeed: rotationSpeed,
      minSpacing: _lerp(270.0, 160.0, t),
      maxSpacing: _lerp(330.0, 220.0, t),
      starWeight: _lerp(0.35, 0.15, t),
      switcherWeight: _lerp(0.30, 0.12, t),
      singleCircleWeight: _lerp(0.40, 0.30, t),
      doubleCircleWeight: _lerp(0.0, 0.18, t),
      specialPatternWeight: _lerp(0.0, 0.12, t),
      horizontalMoveChance: _lerp(0.0, 0.22, t),
      verticalMoveChance: _lerp(0.0, 0.12, t),
      moveAmplitude: _lerp(0.0, 24.0, t),
      moveSpeed: _lerp(0.0, 1.0, t),
      gravity: _lerp(650.0, GameConstants.defaultGravity, t),
      jumpSpeed: _lerp(265.0, 310.0, t),
    );
  }

  double _lerp(double start, double end, double t) => start + (end - start) * t;
}
