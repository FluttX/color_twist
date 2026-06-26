import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
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
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: const Color(0xFFFFD700),
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
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
