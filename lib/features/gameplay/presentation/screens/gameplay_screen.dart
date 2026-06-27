import 'package:color_twist/features/gameplay/models/game_status.dart';
import 'package:color_twist/app/app_services.dart';
import 'package:color_twist/core/retention/retention_engine.dart';
import 'package:color_twist/core/theme/app_theme.dart';
import 'package:color_twist/core/theme/gameplay_theme.dart';
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
  const GameplayScreen({super.key, this.retentionEngine});

  final RetentionEngine? retentionEngine;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameCubit>(
      future: GameCubit.create(
        scoreService: AppServices.instance.scoreService,
        retentionEngine: retentionEngine ?? AppServices.instance.retentionEngine,
        storeService: AppServices.instance.storeService,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocProvider.value(
          value: snapshot.data!,
          child: const _GameplayView(),
        );
      },
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
  }

  SystemUiOverlayStyle _overlayStyle(GameplayTheme theme) {
    final isLight = theme.statusBarBrightness == Brightness.light;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLight ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness:
          isLight ? Brightness.dark : Brightness.light,
      systemNavigationBarContrastEnforced: false,
    );
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
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        final game = context.read<GameCubit>().game;
        final theme = game.config.theme;
        final overlayStyle = _overlayStyle(theme);

        return Theme(
          data: AppTheme.forGameplayTheme(theme),
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: overlayStyle,
            child: Scaffold(
              backgroundColor: theme.scaffoldColor,
              extendBody: true,
              extendBodyBehindAppBar: true,
              body: Stack(
                fit: StackFit.expand,
                children: [
                  MediaQuery.removePadding(
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
                            theme: theme,
                          ),
                        ),
                        Positioned.fill(
                          child: GameWidget(
                            game: game,
                            backgroundBuilder: (context) =>
                                const ColoredBox(color: Colors.transparent),
                          ),
                        ),
                      ],
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
            ),
          ),
        );
      },
    );
  }
}
