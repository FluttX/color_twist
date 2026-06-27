import 'package:color_twist/core/retention/models/goal_progress.dart';
import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:flutter/material.dart';

class DailyChallengeCard extends StatelessWidget {
  const DailyChallengeCard({
    super.key,
    required this.challengeTitle,
    required this.progress,
    required this.coinReward,
  });

  final String challengeTitle;
  final GoalProgress progress;
  final int coinReward;

  static const _gold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      color: const Color(0xFF1A1A2E),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Daily Challenge',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (progress.isComplete)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Complete!',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              challengeTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.fraction,
                minHeight: 8,
                backgroundColor: Colors.white12,
                color: progress.isComplete ? Colors.greenAccent : _gold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${progress.current} / ${progress.target}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Icon(Icons.monetization_on, color: _gold, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$coinReward',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DailyChallengeLoader extends StatefulWidget {
  const DailyChallengeLoader({super.key, required this.retentionEngine});

  final RetentionEngine retentionEngine;

  @override
  State<DailyChallengeLoader> createState() => _DailyChallengeLoaderState();
}

class _DailyChallengeLoaderState extends State<DailyChallengeLoader> {
  GoalProgress? _progress;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final progress = await widget.retentionEngine.getDailyChallengeProgress();
    if (mounted) {
      setState(() => _progress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    if (progress == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final challenge = widget.retentionEngine.getTodaysChallenge();
    return DailyChallengeCard(
      challengeTitle: challenge.title,
      progress: progress,
      coinReward: challenge.coinReward,
    );
  }
}
