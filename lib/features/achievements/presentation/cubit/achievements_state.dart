import 'package:color_twist/features/achievements/data/achievement_catalog.dart';
import 'package:color_twist/features/achievements/models/achievement.dart';
import 'package:equatable/equatable.dart';

class AchievementsState extends Equatable {
  const AchievementsState({
    this.achievements = achievementCatalog,
    this.unlockedById = const {},
    this.isLoading = true,
  });

  final List<Achievement> achievements;
  final Map<String, bool> unlockedById;
  final bool isLoading;

  AchievementsState copyWith({
    List<Achievement>? achievements,
    Map<String, bool>? unlockedById,
    bool? isLoading,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      unlockedById: unlockedById ?? this.unlockedById,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [achievements, unlockedById, isLoading];
}
