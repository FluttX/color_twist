import 'package:color_twist/core/retention/models/goal_metric.dart';
import 'package:color_twist/core/retention/models/goal_scope.dart';
import 'package:equatable/equatable.dart';

class GoalDefinition extends Equatable {
  const GoalDefinition({
    required this.id,
    required this.title,
    required this.metric,
    required this.target,
    required this.scope,
    required this.coinReward,
  });

  final String id;
  final String title;
  final GoalMetric metric;
  final int target;
  final GoalScope scope;
  final int coinReward;

  @override
  List<Object?> get props => [id, title, metric, target, scope, coinReward];
}
