import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/cubit/game_state.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/game_hud.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/game_over_overlay.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/gameplay_parallax_background.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/pause_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({super.key});

  static const _edgeToEdgeOverlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GameCubit(),
      child: const _GameplayView(),
    );
  }
}

class _GameplayView extends StatefulWidget {
  const _GameplayView();

  @override
  State<_GameplayView> createState() => _GameplayViewState();
}

class _GameplayViewState extends State<_GameplayView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(GameplayScreen._edgeToEdgeOverlay);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: GameplayScreen._edgeToEdgeOverlay,
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0C18),
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            final game = context.read<GameCubit>().game;

            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: GameplayParallaxBackground(
                      cameraYListenable: game.cameraYNotifier,
                      driftListenable: game.backgroundDriftNotifier,
                    ),
                  ),
                  Positioned.fill(
                    child: GameWidget(
                      game: game,
                      backgroundBuilder: (context) =>
                          const ColoredBox(color: Colors.transparent),
                    ),
                  ),
                  if (state.status == GameStatus.playing)
                    const Positioned.fill(child: GameHud()),
                  if (state.status == GameStatus.paused)
                    const Positioned.fill(child: PauseOverlay()),
                  if (state.status == GameStatus.gameOver)
                    const Positioned.fill(child: GameOverOverlay()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
