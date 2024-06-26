import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'twist_color_game.dart';

void main() {
  runApp(MaterialApp(home: const HomeScreen(), theme: ThemeData.dark()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TwistColorGame _twistColorGame;

  @override
  void initState() {
    _twistColorGame = TwistColorGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _twistColorGame),
          if (_twistColorGame.isGamePlaying)
            ValueListenableBuilder<bool>(
              valueListenable: _twistColorGame.isGameOver,
              builder: (context, isGameOver, child) {
                if (isGameOver) {
                  return const SizedBox();
                } else {
                  return SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _twistColorGame.pauseGame();
                              });
                            },
                            icon: const Icon(Icons.pause),
                          ),
                          ValueListenableBuilder<int>(
                            valueListenable: _twistColorGame.currentScore,
                            builder: (context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'Score: $value',
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
              },
            ),
          if (_twistColorGame.isGamePaused)
            Container(
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
                        onPressed: () {
                          setState(() {
                            _twistColorGame.resumeGame();
                          });
                        },
                        icon: const Icon(Icons.play_arrow, size: 100),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ValueListenableBuilder<bool>(
            valueListenable: _twistColorGame.isGameOver,
            builder: (context, isGameOver, child) {
              if (isGameOver) {
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
                            onPressed: () {
                              setState(() {
                                _twistColorGame.playAgain();
                              });
                            },
                            icon: const Icon(Icons.play_arrow, size: 100),
                          ),
                        ),
                        Text(
                          'Play Again',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Your Score: ${_twistColorGame.currentScore.value}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
