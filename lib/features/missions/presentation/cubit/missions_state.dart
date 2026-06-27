import 'package:color_twist/core/retention/models/goal_progress.dart';
import 'package:color_twist/features/missions/data/mission_catalog.dart';
import 'package:color_twist/features/missions/models/mission.dart';
import 'package:equatable/equatable.dart';

class MissionsState extends Equatable {
  const MissionsState({
    this.missions = missionCatalog,
    this.progressById = const {},
    this.isLoading = true,
  });

  final List<Mission> missions;
  final Map<String, GoalProgress> progressById;
  final bool isLoading;

  MissionsState copyWith({
    List<Mission>? missions,
    Map<String, GoalProgress>? progressById,
    bool? isLoading,
  }) {
    return MissionsState(
      missions: missions ?? this.missions,
      progressById: progressById ?? this.progressById,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [missions, progressById, isLoading];
}
