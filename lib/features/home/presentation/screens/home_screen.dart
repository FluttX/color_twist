import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:color_twist/features/daily_challenges/presentation/widgets/daily_challenge_card.dart';
import 'package:color_twist/features/gameplay/presentation/screens/gameplay_screen.dart';
import 'package:color_twist/features/missions/presentation/screens/missions_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _gold = Color(0xFFFFD700);

  int _coins = 0;
  int _dailyCardKey = 0;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final engine = AppServices.instance.retentionEngine;
    await engine.initialize();
    if (mounted) {
      setState(() => _coins = engine.coinBalance);
    }
  }

  Future<void> _refreshAfterGameplay() async {
    await _loadCoins();
    setState(() => _dailyCardKey++);
  }

  Future<void> _openGameplay() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameplayScreen(
          retentionEngine: AppServices.instance.retentionEngine,
        ),
      ),
    );
    await _refreshAfterGameplay();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C18),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'Color Twist',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.monetization_on, color: _gold),
                  const SizedBox(width: 6),
                  Text(
                    '$_coins',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: _gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            DailyChallengeLoader(
              key: ValueKey(_dailyCardKey),
              retentionEngine: AppServices.instance.retentionEngine,
            ),
            const Spacer(),
            FilledButton(
              onPressed: _openGameplay,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                child: Text('Play'),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const MissionsScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Missions'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AchievementsScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Achievements'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
