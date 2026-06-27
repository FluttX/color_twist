import 'package:color_twist/core/retention/daily_challenge_service.dart';
import 'package:color_twist/core/retention/models/goal_definition.dart';
import 'package:color_twist/core/retention/models/goal_metric.dart';
import 'package:color_twist/core/retention/models/goal_progress.dart';
import 'package:color_twist/core/retention/models/goal_scope.dart';
import 'package:color_twist/core/retention/models/retention_result.dart';
import 'package:color_twist/core/retention/models/run_stats.dart';
import 'package:color_twist/core/services/coin_service.dart';
import 'package:color_twist/core/services/player_progress_service.dart';
import 'package:color_twist/core/services/score_service.dart';
import 'package:color_twist/features/achievements/data/achievement_catalog.dart';
import 'package:color_twist/features/missions/data/mission_catalog.dart';

class RetentionEngine {
  RetentionEngine._({
    required PlayerProgressService progress,
    required CoinService coins,
    required ScoreService scoreService,
    required DailyChallengeService daily,
  })  : _progress = progress,
        _coins = coins,
        _scoreService = scoreService,
        _daily = daily;

  factory RetentionEngine({
    PlayerProgressService? progressService,
    CoinService? coinService,
    ScoreService? scoreService,
    DailyChallengeService? dailyChallengeService,
  }) {
    final progress = progressService ?? PlayerProgressService();
    return RetentionEngine._(
      progress: progress,
      coins: coinService ?? CoinService(progressService: progress),
      scoreService: scoreService ?? ScoreService(),
      daily: dailyChallengeService ?? DailyChallengeService(),
    );
  }

  final PlayerProgressService _progress;
  final CoinService _coins;
  final ScoreService _scoreService;
  final DailyChallengeService _daily;

  Future<void> initialize() async {
    await _progress.initialize();
    await _coins.initialize();
    await _scoreService.initialize();
  }

  int get coinBalance => _coins.balance;

  Future<RetentionResult> processRun(RunStats stats) async {
    await initialize();

    await _progress.incrementLifetimeStats(
      stars: stats.starsCollected,
      jumps: stats.jumps,
      colorChanges: stats.colorChanges,
      games: stats.gamesPlayed,
    );

    var coinsEarned = 0;
    final completedDaily = <String>[];
    final completedMissions = <String>[];
    final unlockedAchievements = <String>[];

    final dailyResult = await _processDailyChallenge(stats);
    if (dailyResult != null) {
      completedDaily.add(dailyResult);
      final challenge = _daily.getTodaysChallenge();
      coinsEarned += challenge.coinReward;
    }

    final missionResults = await _processMissions(stats);
    for (final missionId in missionResults) {
      completedMissions.add(missionId);
      final mission = missionCatalog.firstWhere((m) => m.id == missionId);
      coinsEarned += mission.definition.coinReward;
    }

    final achievementResults = await _processAchievements(stats);
    for (final achievementId in achievementResults) {
      unlockedAchievements.add(achievementId);
      final achievement =
          achievementCatalog.firstWhere((a) => a.id == achievementId);
      coinsEarned += achievement.coinReward;
    }

    if (coinsEarned > 0) {
      await _coins.addCoins(coinsEarned);
    }

    return RetentionResult(
      completedDailyChallengeIds: completedDaily,
      completedMissionIds: completedMissions,
      unlockedAchievementIds: unlockedAchievements,
      coinsEarned: coinsEarned,
    );
  }

  Future<String?> _processDailyChallenge(RunStats stats) async {
    final today = _daily.todayDateKey;
    final challenge = _daily.getTodaysChallenge();

    var progress = _progress.dailyProgress;
    var complete = _progress.dailyComplete;
    var claimed = _progress.dailyClaimed;
    var challengeId = _progress.dailyChallengeId;

    if (_progress.dailyDate != today || challengeId != challenge.id) {
      progress = 0;
      complete = false;
      claimed = false;
      challengeId = challenge.id;
    }

    if (!complete) {
      progress = _advanceProgress(
        challenge,
        progress,
        stats,
        isDaily: true,
      );
      complete = _isGoalComplete(challenge, progress, stats);
    }

    await _progress.setDailyState(
      date: today,
      challengeId: challengeId,
      progress: progress,
      complete: complete,
      claimed: complete || claimed,
    );

    if (complete && !claimed) {
      return challenge.id;
    }
    return null;
  }

  Future<List<String>> _processMissions(RunStats stats) async {
    final newlyCompleted = <String>[];

    for (final mission in missionCatalog) {
      final definition = mission.definition;
      var progress = await _progress.getMissionProgress(definition.id);
      final claimed = await _progress.isMissionClaimed(definition.id);

      if (!claimed) {
        progress = _advanceProgress(definition, progress, stats);
        await _progress.setMissionProgress(definition.id, progress);

        if (_isGoalComplete(definition, progress, stats) && !claimed) {
          await _progress.setMissionClaimed(definition.id, true);
          newlyCompleted.add(definition.id);
        }
      }
    }

    return newlyCompleted;
  }

  Future<List<String>> _processAchievements(RunStats stats) async {
    final newlyUnlocked = <String>[];
    final bestScore = _scoreService.highScore;

    for (final achievement in achievementCatalog) {
      final alreadyUnlocked =
          await _progress.isAchievementUnlocked(achievement.id);
      if (alreadyUnlocked) continue;

      final unlocked = switch (achievement.id) {
        'first_game' => _progress.gamesPlayed >= 1,
        'score_10' => bestScore >= 10,
        'score_50' => bestScore >= 50,
        'score_100' => bestScore >= 100,
        'stars_100' => _progress.totalStars >= 100,
        'perfect_run' => stats.hasNoStarMisses && stats.score >= 10,
        _ => false,
      };

      if (unlocked) {
        await _progress.setAchievementUnlocked(achievement.id, true);
        newlyUnlocked.add(achievement.id);
      }
    }

    return newlyUnlocked;
  }

  Future<GoalProgress> getDailyChallengeProgress() async {
    await initialize();
    final challenge = _daily.getTodaysChallenge();
    final today = _daily.todayDateKey;

    if (_progress.dailyDate != today ||
        _progress.dailyChallengeId != challenge.id) {
      return GoalProgress(
        current: 0,
        target: challenge.target,
        isComplete: false,
        claimed: false,
      );
    }

    return GoalProgress(
      current: _progress.dailyProgress.clamp(0, challenge.target),
      target: challenge.target,
      isComplete: _progress.dailyComplete,
      claimed: _progress.dailyClaimed,
    );
  }

  GoalDefinition getTodaysChallenge() => _daily.getTodaysChallenge();

  Future<GoalProgress> getMissionProgress(String missionId) async {
    await initialize();
    final mission = missionCatalog.firstWhere((m) => m.id == missionId);
    final claimed = await _progress.isMissionClaimed(missionId);
    final current = _lifetimeValueForMetric(mission.definition.metric)
        .clamp(0, mission.definition.target);

    return GoalProgress(
      current: current,
      target: mission.definition.target,
      isComplete: _isLifetimeComplete(mission.definition),
      claimed: claimed,
    );
  }

  Future<bool> isAchievementUnlocked(String achievementId) async {
    await initialize();
    return _progress.isAchievementUnlocked(achievementId);
  }

  int _advanceProgress(
    GoalDefinition goal,
    int current,
    RunStats stats, {
    bool isDaily = false,
  }) {
    return switch (goal.metric) {
      GoalMetric.collectStars => isDaily || goal.scope == GoalScope.daily
          ? current + stats.starsCollected
          : _lifetimeValueForMetric(goal.metric),
      GoalMetric.reachScore => goal.scope == GoalScope.singleRun
          ? (stats.score > current ? stats.score : current)
          : _lifetimeValueForMetric(goal.metric),
      GoalMetric.jumpCount => isDaily || goal.scope == GoalScope.daily
          ? current + stats.jumps
          : _lifetimeValueForMetric(goal.metric),
      GoalMetric.colorChanges => isDaily || goal.scope == GoalScope.daily
          ? current + stats.colorChanges
          : _lifetimeValueForMetric(goal.metric),
      GoalMetric.playGames => isDaily || goal.scope == GoalScope.daily
          ? current + stats.gamesPlayed
          : _lifetimeValueForMetric(goal.metric),
      GoalMetric.noStarMisses => stats.hasNoStarMisses
          ? (current + 1).clamp(0, goal.target)
          : current,
    };
  }

  bool _isGoalComplete(GoalDefinition goal, int progress, RunStats stats) {
    if (goal.metric == GoalMetric.reachScore && goal.scope == GoalScope.singleRun) {
      return stats.score >= goal.target;
    }
    if (goal.metric == GoalMetric.noStarMisses && goal.scope == GoalScope.singleRun) {
      return stats.hasNoStarMisses && progress >= goal.target;
    }
    if (goal.scope == GoalScope.lifetime) {
      return _isLifetimeComplete(goal);
    }
    return progress >= goal.target;
  }

  bool _isLifetimeComplete(GoalDefinition goal) {
    return _lifetimeValueForMetric(goal.metric) >= goal.target;
  }

  int _lifetimeValueForMetric(GoalMetric metric) {
    return switch (metric) {
      GoalMetric.collectStars => _progress.totalStars,
      GoalMetric.reachScore => _scoreService.highScore,
      GoalMetric.jumpCount => _progress.totalJumps,
      GoalMetric.colorChanges => _progress.totalColorChanges,
      GoalMetric.playGames => _progress.gamesPlayed,
      GoalMetric.noStarMisses => 0,
    };
  }
}
