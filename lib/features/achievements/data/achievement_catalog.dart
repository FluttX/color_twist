import 'package:color_twist/features/achievements/models/achievement.dart';

const achievementCatalog = <Achievement>[
  Achievement(
    id: 'first_game',
    title: 'First Game',
    description: 'Complete your first run.',
    coinReward: 25,
  ),
  Achievement(
    id: 'score_10',
    title: 'Score 10',
    description: 'Reach a best score of 10.',
    coinReward: 25,
  ),
  Achievement(
    id: 'score_50',
    title: 'Score 50',
    description: 'Reach a best score of 50.',
    coinReward: 50,
  ),
  Achievement(
    id: 'score_100',
    title: 'Score 100',
    description: 'Reach a best score of 100.',
    coinReward: 100,
  ),
  Achievement(
    id: 'stars_100',
    title: 'Collect 100 stars',
    description: 'Collect 100 stars in total.',
    coinReward: 50,
  ),
  Achievement(
    id: 'perfect_run',
    title: 'Perfect Run',
    description: 'Finish a run with score 10+ and no missed stars.',
    coinReward: 75,
  ),
];
