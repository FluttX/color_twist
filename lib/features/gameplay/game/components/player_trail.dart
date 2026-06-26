import 'dart:math';

import 'package:color_twist/features/gameplay/game/components/player.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class PlayerTrail extends Component with HasGameReference<TwistColorGame> {
  PlayerTrail({required this.player});

  final Player player;
  final _rnd = Random();

  @override
  void update(double dt) {
    super.update(dt);
    if (player.isOnGround) {
      return;
    }

    game.world.add(
      ParticleSystemComponent(
        position: player.position.clone(),
        particle: Particle.generate(
          count: 2,
          lifespan: 0.25,
          generator: (i) {
            return AcceleratedParticle(
              speed: Vector2(
                (_rnd.nextDouble() - 0.5) * 20,
                40 + _rnd.nextDouble() * 30,
              ),
              acceleration: Vector2(0, 60),
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  final color = player.currentColor.withValues(
                    alpha: (1 - particle.progress) * 0.6,
                  );
                  canvas.drawCircle(
                    Offset.zero,
                    3 * (1 - particle.progress * 0.5),
                    Paint()..color = color,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
