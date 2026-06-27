import 'package:equatable/equatable.dart';

class GoalProgress extends Equatable {
  const GoalProgress({
    required this.current,
    required this.target,
    required this.isComplete,
    required this.claimed,
  });

  final int current;
  final int target;
  final bool isComplete;
  final bool claimed;

  double get fraction =>
      target == 0 ? 0 : (current / target).clamp(0.0, 1.0);

  GoalProgress copyWith({
    int? current,
    int? target,
    bool? isComplete,
    bool? claimed,
  }) {
    return GoalProgress(
      current: current ?? this.current,
      target: target ?? this.target,
      isComplete: isComplete ?? this.isComplete,
      claimed: claimed ?? this.claimed,
    );
  }

  @override
  List<Object?> get props => [current, target, isComplete, claimed];
}
