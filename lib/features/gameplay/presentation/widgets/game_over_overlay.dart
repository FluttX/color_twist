import 'package:color_twist/core/retention/models/retention_result.dart';
import 'package:color_twist/features/achievements/data/achievement_catalog.dart';
import 'package:color_twist/features/daily_challenges/data/daily_challenge_pool.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:color_twist/features/missions/data/mission_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({super.key});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  static const _gold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<GameCubit, GameState>(
                buildWhen: (previous, current) =>
                    previous.isNewHighScore != current.isNewHighScore,
                builder: (context, state) {
                  if (state.isNewHighScore) {
                    return Column(
                      children: [
                        Text(
                          'New High Score!',
                          style:
                              Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: _gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }
                  return Text(
                    'Game Over',
                    style: Theme.of(context).textTheme.headlineLarge,
                  );
                },
              ),
              SizedBox(
                height: 140,
                width: 140,
                child: IconButton(
                  onPressed: context.read<GameCubit>().playAgain,
                  icon: const Icon(Icons.play_arrow, size: 100),
                ),
              ),
              Text(
                'Play Again',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              BlocBuilder<GameCubit, GameState>(
                buildWhen: (previous, current) =>
                    previous.score != current.score ||
                    previous.highScore != current.highScore,
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        'Your Score: ${state.score}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (state.highScore > 0) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Best: ${state.highScore}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<GameCubit, GameState>(
                buildWhen: (previous, current) =>
                    previous.lastRetentionResult != current.lastRetentionResult,
                builder: (context, state) {
                  final result = state.lastRetentionResult;
                  if (result == null || !result.hasRewards) {
                    return const SizedBox.shrink();
                  }

                  return _RetentionRewards(result: result);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RetentionRewards extends StatefulWidget {
  const _RetentionRewards({required this.result});

  final RetentionResult result;

  @override
  State<_RetentionRewards> createState() => _RetentionRewardsState();
}

class _RetentionRewardsState extends State<_RetentionRewards>
    with SingleTickerProviderStateMixin {
  static const _gold = Color(0xFFFFD700);
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final chips = <String>[];

    for (final id in result.completedDailyChallengeIds) {
      final challenge = dailyChallengePool.firstWhere((c) => c.id == id);
      chips.add('Daily: ${challenge.title}');
    }
    for (final id in result.completedMissionIds) {
      final mission = missionCatalog.firstWhere((m) => m.id == id);
      chips.add('Mission: ${mission.definition.title}');
    }
    for (final id in result.unlockedAchievementIds) {
      final achievement = achievementCatalog.firstWhere((a) => a.id == id);
      chips.add('Achievement: ${achievement.title}');
    }

    return FadeTransition(
      opacity: _opacity,
      child: Column(
        children: [
          if (result.coinsEarned > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: _gold),
                const SizedBox(width: 6),
                Text(
                  '+${result.coinsEarned} coins',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _gold,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map(
                  (label) => Chip(
                    label: Text(label),
                    backgroundColor: const Color(0xFF1A1A2E),
                    side: const BorderSide(color: _gold),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
