import 'package:equatable/equatable.dart';

class RunStats extends Equatable {
  const RunStats({
    required this.score,
    required this.starsCollected,
    required this.jumps,
    required this.colorChanges,
    required this.starsMissed,
    this.gamesPlayed = 1,
  });

  final int score;
  final int starsCollected;
  final int jumps;
  final int colorChanges;
  final int starsMissed;
  final int gamesPlayed;

  bool get hasNoStarMisses => starsMissed == 0;

  @override
  List<Object?> get props => [
        score,
        starsCollected,
        jumps,
        colorChanges,
        starsMissed,
        gamesPlayed,
      ];
}
