import 'package:color_twist/core/retention/models/goal_progress.dart';
import 'package:color_twist/features/missions/models/mission.dart';
import 'package:flutter/material.dart';

class MissionTile extends StatelessWidget {
  const MissionTile({
    super.key,
    required this.mission,
    required this.progress,
  });

  final Mission mission;
  final GoalProgress progress;

  static const _gold = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    mission.definition.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (progress.claimed)
                  const Icon(Icons.check_circle, color: Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              mission.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.fraction,
                minHeight: 8,
                backgroundColor: theme.dividerColor,
                color: progress.isComplete ? Colors.greenAccent : _gold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${progress.current} / ${progress.target}',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Icon(Icons.monetization_on, color: _gold, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${mission.definition.coinReward}',
                  style: theme.textTheme.bodySmall?.copyWith(
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
