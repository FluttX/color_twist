import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
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
          top: 0,
          left: 0,
          child: SafeArea(
            bottom: false,
            right: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: IconButton(
                onPressed: context.read<GameCubit>().resume,
                icon: const Icon(Icons.play_arrow, size: 28),
                tooltip: 'Resume',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
