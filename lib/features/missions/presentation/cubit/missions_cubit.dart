import 'package:color_twist/core/retention/models/goal_progress.dart';
import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:color_twist/features/missions/data/mission_catalog.dart';
import 'package:color_twist/features/missions/presentation/cubit/missions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsCubit extends Cubit<MissionsState> {
  MissionsCubit({required RetentionEngine retentionEngine})
      : _retentionEngine = retentionEngine,
        super(const MissionsState()) {
    load();
  }

  final RetentionEngine _retentionEngine;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final progressById = <String, GoalProgress>{};
    for (final mission in missionCatalog) {
      progressById[mission.id] =
          await _retentionEngine.getMissionProgress(mission.id);
    }
    emit(
      state.copyWith(
        progressById: progressById,
        isLoading: false,
      ),
    );
  }
}
