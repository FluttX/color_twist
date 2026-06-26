import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHud extends StatelessWidget {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GameCubit>();

    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: cubit.pause,
              icon: const Icon(Icons.pause),
            ),
            BlocBuilder<GameCubit, GameState>(
              buildWhen: (previous, current) => previous.score != current.score,
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Score: ${state.score}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
