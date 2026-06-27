import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/core/debug/developer_options.dart';
import 'package:color_twist/core/theme/gameplay_theme.dart';
import 'package:color_twist/features/achievements/presentation/screens/achievements_screen.dart';
import 'package:color_twist/features/daily_challenges/presentation/widgets/daily_challenge_card.dart';
import 'package:color_twist/features/gameplay/presentation/screens/gameplay_screen.dart';
import 'package:color_twist/features/home/presentation/widgets/developer_options_sheet.dart';
import 'package:color_twist/features/missions/presentation/screens/missions_screen.dart';
import 'package:color_twist/features/store/presentation/screens/store_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onThemeChanged});

  final VoidCallback? onThemeChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _gold = Color(0xFFFFD700);

  int _coins = 0;
  int _dailyCardKey = 0;
  GameplayTheme _theme = GameplayTheme.dark;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final engine = AppServices.instance.retentionEngine;
    await engine.initialize();
    final theme = await AppServices.instance.storeService.loadTheme();
    if (mounted) {
      setState(() {
        _coins = engine.coinBalance;
        _theme = theme;
      });
    }
  }

  Future<void> _refreshAfterGameplay() async {
    await _loadData();
    widget.onThemeChanged?.call();
    setState(() => _dailyCardKey++);
  }

  Future<void> _openStore() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StoreScreen(theme: _theme),
      ),
    );
    await _loadData();
    widget.onThemeChanged?.call();
    if (mounted) setState(() {});
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
      backgroundColor: _theme.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onLongPress: DeveloperOptions.isAvailable
                        ? () => DeveloperOptionsSheet.show(context)
                        : null,
                    child: Text(
                      'Color Twist',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (DeveloperOptions.isAvailable &&
                      DeveloperOptions.unlockAllStoreItems)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        tooltip: 'Developer options',
                        onPressed: () => DeveloperOptionsSheet.show(context),
                        icon: Icon(
                          Icons.developer_mode,
                          color: _theme.accentColor,
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: _openStore,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: _gold),
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
              onPressed: _openStore,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Store'),
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            if (DeveloperOptions.isAvailable)
              TextButton.icon(
                onPressed: () => DeveloperOptionsSheet.show(context),
                icon: const Icon(Icons.developer_mode, size: 18),
                label: const Text('Developer options'),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
