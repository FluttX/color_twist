import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/game_hud.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/game_over_overlay.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/pause_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: const _GameplayView(),
    );
  }
}

class _GameplayView extends StatelessWidget {
  const _GameplayView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          final game = context.read<GameCubit>().game;

          return Stack(
            children: [
              GameWidget(game: game),
              if (state.status == GameStatus.playing) const GameHud(),
              if (state.status == GameStatus.paused) const PauseOverlay(),
              if (state.status == GameStatus.gameOver) const GameOverOverlay(),
            ],
          );
        },
      ),
    );
  }
}
