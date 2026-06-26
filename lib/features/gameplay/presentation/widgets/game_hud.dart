import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHud extends StatelessWidget {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: cubit.pause,
                    icon: const Icon(Icons.pause, size: 28),
                    tooltip: 'Pause',
                  ),
                  const Spacer(),
                  BlocBuilder<GameCubit, GameState>(
                    buildWhen: (previous, current) =>
                        previous.score != current.score ||
                        previous.highScore != current.highScore,
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Score: ${state.score}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (state.highScore > 0)
                              Text(
                                'Best: ${state.highScore}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white70),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
