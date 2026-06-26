import 'dart:math';

import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:color_twist/core/constants/game_constants.dart';
import 'package:color_twist/features/gameplay/game/particles/particle_burst_builder.dart';
import 'package:color_twist/features/gameplay/game/particles/particle_presets.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ParticleEffects extends Component with HasGameReference<TwistColorGame> {
  Sprite? _starSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _starSprite = await Sprite.load(AssetPaths.starIcon);
  }

  /// World-local coordinates — particles scroll with the camera.
  Component get _world => game.world;

  /// Viewport-local coordinates — fixed on screen (e.g. confetti from top).
  Component get _viewport => game.camera.viewport;

  void playStarCollect(Vector2 position) {
    final sprite = _starSprite;
    if (sprite == null) return;

    final preset = ParticlePresets.starCollect;
    final starSize = Vector2(28, 28);

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: preset.count,
      lifespan: preset.lifespan,
      priority: preset.priority,
      speed: (rnd) =>
          ParticleBurstBuilder.randomRadialVector(rnd, preset.speedMagnitude),
      acceleration: (rnd) => ParticleBurstBuilder.randomRadialVector(
        rnd,
        preset.accelerationMagnitude,
      ),
      childBuilder: (i, rnd, _) {
        return RotatingParticle(
          to: rnd.nextDouble() * pi * 2,
          child: ComputedParticle(
            renderer: ParticleBurstBuilder.spriteRenderer(
              sprite: sprite,
              size: starSize,
              maxAlpha: 1.0,
            ),
          ),
        );
      },
    );
  }

  void playColorSwitch(Vector2 position, Color newColor, List<Color> palette) {
    final preset = ParticlePresets.colorSwitch;

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: preset.count,
      lifespan: preset.lifespan,
      priority: preset.priority,
      speed: (rnd) =>
          ParticleBurstBuilder.randomRadialVector(rnd, preset.speedMagnitude),
      acceleration: (rnd) => ParticleBurstBuilder.randomRadialVector(
        rnd,
        preset.accelerationMagnitude,
      ),
      childBuilder: (i, rnd, _) {
        final color = palette[rnd.nextInt(palette.length)];
        return ComputedParticle(
          renderer: ParticleBurstBuilder.circleRenderer(
            color: color,
            radius: 4 + rnd.nextDouble() * 3,
            maxAlpha: 0.9,
          ),
        );
      },
    );

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: 8,
      lifespan: 0.4,
      priority: preset.priority + 1,
      speed: (rnd) {
        final angle = rnd.nextDouble() * pi * 2;
        final speed = 40 + rnd.nextDouble() * 30;
        return Vector2(cos(angle) * speed, sin(angle) * speed);
      },
      acceleration: (_) => Vector2.zero(),
      childBuilder: (i, rnd, _) {
        return ComputedParticle(
          renderer: ParticleBurstBuilder.circleRenderer(
            color: newColor,
            radius: 6,
            maxAlpha: 0.7,
            minScale: 0.2,
          ),
        );
      },
    );
  }

  void playGameOverExplosion(Vector2 position, Color playerColor) {
    final preset = ParticlePresets.gameOverExplosion;

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: preset.count,
      lifespan: preset.lifespan,
      priority: preset.priority,
      speed: (rnd) =>
          ParticleBurstBuilder.randomRadialVector(rnd, preset.speedMagnitude),
      acceleration: (rnd) => ParticleBurstBuilder.randomRadialVector(
        rnd,
        preset.accelerationMagnitude,
      ),
      childBuilder: (i, rnd, _) {
        final useWhite = rnd.nextBool();
        final color = useWhite ? Colors.white : playerColor;
        return ComputedParticle(
          renderer: ParticleBurstBuilder.circleRenderer(
            color: color,
            radius: 5 + rnd.nextDouble() * 6,
            maxAlpha: 1.0,
          ),
        );
      },
    );
  }

  void playPerfectCombo(Vector2 position, int comboCount) {
    final preset = ParticlePresets.perfectCombo;
    final intensity = (comboCount / 10).clamp(1.0, 3.0);
    final count = (preset.count * intensity).round();

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: count,
      lifespan: preset.lifespan,
      priority: preset.priority,
      speed: (rnd) => ParticleBurstBuilder.randomRadialVector(
        rnd,
        preset.speedMagnitude * intensity,
      ),
      acceleration: (rnd) => Vector2(0, -20 - rnd.nextDouble() * 30),
      childBuilder: (i, rnd, _) {
        final color =
            ParticlePresets.comboColors[rnd.nextInt(ParticlePresets.comboColors.length)];
        return RotatingParticle(
          to: rnd.nextDouble() * pi,
          child: ComputedParticle(
            renderer: ParticleBurstBuilder.circleRenderer(
              color: color,
              radius: 3 + rnd.nextDouble() * 4 * intensity,
              maxAlpha: 0.95,
            ),
          ),
        );
      },
    );

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: 12,
      lifespan: 0.5,
      priority: preset.priority + 1,
      speed: (rnd) {
        final angle = rnd.nextDouble() * pi * 2;
        final speed = 50 + rnd.nextDouble() * 40;
        return Vector2(cos(angle) * speed, sin(angle) * speed);
      },
      acceleration: (_) => Vector2.zero(),
      childBuilder: (i, rnd, _) {
        return ComputedParticle(
          renderer: ParticleBurstBuilder.circleRenderer(
            color: const Color(0xFFFFD700),
            radius: 8,
            maxAlpha: 0.6,
            minScale: 0.1,
          ),
        );
      },
    );
  }

  void playNewHighScore() {
    final preset = ParticlePresets.newHighScore;
    final cameraWidth = GameConstants.cameraWidth;
    final cameraHeight = GameConstants.cameraHeight;
    final topY = -cameraHeight / 2;

    for (var i = 0; i < preset.count; i++) {
      final x = (Random().nextDouble() - 0.5) * cameraWidth;
      final y = topY - Random().nextDouble() * 40;

      ParticleBurstBuilder.spawnOn(
        _viewport,
        position: Vector2(x, y),
        count: 1,
        lifespan: preset.lifespan + Random().nextDouble() * 0.4,
        priority: preset.priority,
        speed: (rnd) => Vector2(
          (rnd.nextDouble() - 0.5) * 60,
          80 + rnd.nextDouble() * preset.speedMagnitude,
        ),
        acceleration: (rnd) => Vector2(0, preset.accelerationMagnitude),
        childBuilder: (index, rnd, _) {
          final color = ParticlePresets.confettiColors[
              rnd.nextInt(ParticlePresets.confettiColors.length)];
          final isRect = rnd.nextBool();
          if (isRect) {
            return RotatingParticle(
              to: rnd.nextDouble() * pi * 2,
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  final alpha =
                      ParticleBurstBuilder.fadeAlpha(particle.progress, maxAlpha: 0.9);
                  final size = ParticleBurstBuilder.fadeSize(6, particle.progress);
                  canvas.drawRect(
                    Rect.fromCenter(
                      center: Offset.zero,
                      width: size * 1.5,
                      height: size,
                    ),
                    Paint()..color = color.withValues(alpha: alpha),
                  );
                },
              ),
            );
          }
          return ComputedParticle(
            renderer: ParticleBurstBuilder.circleRenderer(
              color: color,
              radius: 4 + rnd.nextDouble() * 3,
              maxAlpha: 0.9,
            ),
          );
        },
      );
    }
  }

  void playTrailDrip(Vector2 position, Color color) {
    final preset = ParticlePresets.trailDrip;

    ParticleBurstBuilder.spawnOn(
      _world,
      position: position,
      count: preset.count,
      lifespan: preset.lifespan,
      priority: preset.priority,
      speed: (random) => Vector2(
        (random.nextDouble() - 0.5) * 20,
        40 + random.nextDouble() * 30,
      ),
      acceleration: (_) => Vector2(0, preset.accelerationMagnitude),
      childBuilder: (i, random, _) {
        return ComputedParticle(
          renderer: ParticleBurstBuilder.circleRenderer(
            color: color,
            radius: 3,
            maxAlpha: 0.6,
            minScale: 0.5,
          ),
        );
      },
    );
  }
}
