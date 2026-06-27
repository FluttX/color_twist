import 'package:color_twist/core/retention/models/goal_definition.dart';
import 'package:color_twist/core/retention/models/goal_metric.dart';
import 'package:color_twist/core/retention/models/goal_scope.dart';

const dailyChallengePool = <GoalDefinition>[
  GoalDefinition(
    id: 'daily_stars_30',
    title: 'Collect 30 stars',
    metric: GoalMetric.collectStars,
    target: 30,
    scope: GoalScope.daily,
    coinReward: 50,
  ),
  GoalDefinition(
    id: 'daily_score_50',
    title: 'Reach score 50',
    metric: GoalMetric.reachScore,
    target: 50,
    scope: GoalScope.singleRun,
    coinReward: 75,
  ),
  GoalDefinition(
    id: 'daily_jumps_200',
    title: 'Jump 200 times',
    metric: GoalMetric.jumpCount,
    target: 200,
    scope: GoalScope.daily,
    coinReward: 50,
  ),
  GoalDefinition(
    id: 'daily_no_misses',
    title: 'No missed stars',
    metric: GoalMetric.noStarMisses,
    target: 1,
    scope: GoalScope.singleRun,
    coinReward: 100,
  ),
];
