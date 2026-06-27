import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:color_twist/features/achievements/data/achievement_catalog.dart';
import 'package:color_twist/features/achievements/presentation/cubit/achievements_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit({required RetentionEngine retentionEngine})
      : _retentionEngine = retentionEngine,
        super(const AchievementsState()) {
    load();
  }

  final RetentionEngine _retentionEngine;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final unlockedById = <String, bool>{};
    for (final achievement in achievementCatalog) {
      unlockedById[achievement.id] =
          await _retentionEngine.isAchievementUnlocked(achievement.id);
    }
    emit(
      state.copyWith(
        unlockedById: unlockedById,
        isLoading: false,
      ),
    );
  }
}
