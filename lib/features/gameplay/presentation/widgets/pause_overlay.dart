import 'package:color_twist/features/gameplay/presentation/cubit/game_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PAUSED!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: 140,
              width: 140,
              child: IconButton(
                onPressed: context.read<GameCubit>().resume,
                icon: const Icon(Icons.play_arrow, size: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
