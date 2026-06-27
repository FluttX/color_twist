import 'package:equatable/equatable.dart';

class RetentionResult extends Equatable {
  const RetentionResult({
    this.completedDailyChallengeIds = const [],
    this.completedMissionIds = const [],
    this.unlockedAchievementIds = const [],
    this.coinsEarned = 0,
  });

  final List<String> completedDailyChallengeIds;
  final List<String> completedMissionIds;
  final List<String> unlockedAchievementIds;
  final int coinsEarned;

  bool get hasRewards =>
      coinsEarned > 0 ||
      completedDailyChallengeIds.isNotEmpty ||
      completedMissionIds.isNotEmpty ||
      unlockedAchievementIds.isNotEmpty;

  @override
  List<Object?> get props => [
        completedDailyChallengeIds,
        completedMissionIds,
        unlockedAchievementIds,
        coinsEarned,
      ];
}
