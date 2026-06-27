import 'package:color_twist/core/retention/models/goal_definition.dart';
import 'package:color_twist/features/daily_challenges/data/daily_challenge_pool.dart';

class DailyChallengeService {
  DailyChallengeService({DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  String get todayDateKey {
    final now = _now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  int get todaySeed {
    final now = _now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  GoalDefinition getTodaysChallenge() {
    final pool = dailyChallengePool;
    final index = todaySeed % pool.length;
    return pool[index];
  }
}
