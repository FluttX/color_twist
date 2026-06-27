import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/features/achievements/presentation/cubit/achievements_cubit.dart';
import 'package:color_twist/features/achievements/presentation/cubit/achievements_state.dart';
import 'package:color_twist/features/achievements/presentation/widgets/achievement_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AchievementsCubit(
        retentionEngine: AppServices.instance.retentionEngine,
      ),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatelessWidget {
  const _AchievementsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: const Color(0xFF0C0C18),
      ),
      backgroundColor: const Color(0xFF0C0C18),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.achievements.length,
            itemBuilder: (context, index) {
              final achievement = state.achievements[index];
              final unlocked = state.unlockedById[achievement.id] ?? false;

              return AchievementTile(
                achievement: achievement,
                unlocked: unlocked,
              );
            },
          );
        },
      ),
    );
  }
}
