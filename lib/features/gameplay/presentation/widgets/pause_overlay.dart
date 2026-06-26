import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:color_twist/features/gameplay/presentation/widgets/game_hud.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top + kGameHudTopPadding;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black45),
        const Center(
          child: Text(
            'PAUSED!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: topInset,
          left: 4,
          child: IconButton(
            onPressed: context.read<GameCubit>().resume,
            icon: const Icon(Icons.play_arrow, size: 28),
            tooltip: 'Resume',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 48,
            ),
          ),
        ),
      ],
    );
  }
}
