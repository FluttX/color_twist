import 'package:color_twist/core/retention/models/goal_definition.dart';
import 'package:equatable/equatable.dart';

class Mission extends Equatable {
  const Mission({
    required this.definition,
    required this.description,
  });

  final GoalDefinition definition;
  final String description;

  String get id => definition.id;

  @override
  List<Object?> get props => [definition, description];
}
