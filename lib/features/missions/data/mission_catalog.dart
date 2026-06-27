import 'package:color_twist/core/retention/models/goal_definition.dart';
import 'package:color_twist/core/retention/models/goal_metric.dart';
import 'package:color_twist/core/retention/models/goal_scope.dart';
import 'package:color_twist/features/missions/models/mission.dart';

const missionCatalog = <Mission>[
  Mission(
    definition: GoalDefinition(
      id: 'mission_score_100',
      title: 'Reach 100 score',
      metric: GoalMetric.reachScore,
      target: 100,
      scope: GoalScope.lifetime,
      coinReward: 150,
    ),
    description: 'Set a personal best of 100 or higher.',
  ),
  Mission(
    definition: GoalDefinition(
      id: 'mission_stars_500',
      title: 'Collect 500 stars',
      metric: GoalMetric.collectStars,
      target: 500,
      scope: GoalScope.lifetime,
      coinReward: 200,
    ),
    description: 'Collect 500 stars across all runs.',
  ),
  Mission(
    definition: GoalDefinition(
      id: 'mission_colors_300',
      title: 'Change color 300 times',
      metric: GoalMetric.colorChanges,
      target: 300,
      scope: GoalScope.lifetime,
      coinReward: 150,
    ),
    description: 'Hit 300 color switchers in total.',
  ),
  Mission(
    definition: GoalDefinition(
      id: 'mission_games_5',
      title: 'Play 5 games',
      metric: GoalMetric.playGames,
      target: 5,
      scope: GoalScope.lifetime,
      coinReward: 100,
    ),
    description: 'Finish 5 runs.',
  ),
];
