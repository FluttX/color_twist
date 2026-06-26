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
            Text(
              'Game Over',
              style: Theme.of(context).textTheme.headlineLarge,
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
              buildWhen: (previous, current) => previous.score != current.score,
              builder: (context, state) {
                return Text(
                  'Your Score: ${state.score}',
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
