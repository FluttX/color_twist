import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

typedef ParticleChildBuilder = Particle Function(
  int index,
  Random random,
  double progress,
);

class ParticleBurstBuilder {
  ParticleBurstBuilder._();

  static double fadeAlpha(double progress, {double maxAlpha = 1.0}) {
    return (1 - progress) * maxAlpha;
  }

  static double fadeSize(double baseSize, double progress, {double minScale = 0.0}) {
    return baseSize * (1 - progress * (1 - minScale));
  }

  static void Function(Canvas, Particle) circleRenderer({
    required Color color,
    required double radius,
    double maxAlpha = 1.0,
    double minScale = 0.5,
  }) {
    return (canvas, particle) {
      final alpha = fadeAlpha(particle.progress, maxAlpha: maxAlpha);
      final size = fadeSize(radius, particle.progress, minScale: minScale);
      canvas.drawCircle(
        Offset.zero,
        size,
        Paint()..color = color.withValues(alpha: alpha),
      );
    };
  }

  static void Function(Canvas, Particle) spriteRenderer({
    required Sprite sprite,
    required Vector2 size,
    Color? color,
    double maxAlpha = 1.0,
  }) {
    return (canvas, particle) {
      final alpha = fadeAlpha(particle.progress, maxAlpha: maxAlpha);
      final renderSize = size * (1 - particle.progress);
      sprite.render(
        canvas,
        size: renderSize,
        anchor: Anchor.center,
        overridePaint: color != null
            ? (Paint()..color = color.withValues(alpha: alpha))
            : (Paint()..color = Colors.white.withValues(alpha: alpha)),
      );
    };
  }

  static Vector2 randomRadialVector(Random random, double magnitude) {
    return (Vector2.random(random) - Vector2.random(random)) * magnitude;
  }

  static void spawnOn(
    Component parent, {
    required Vector2 position,
    required int count,
    required double lifespan,
    required ParticleChildBuilder childBuilder,
    Vector2 Function(Random random)? speed,
    Vector2 Function(Random random)? acceleration,
    int priority = 100,
  }) {
    final random = Random();
    parent.add(
      ParticleSystemComponent(
        position: position,
        priority: priority,
        particle: Particle.generate(
          count: count,
          lifespan: lifespan,
          generator: (i) {
            return AcceleratedParticle(
              speed: speed?.call(random) ?? randomRadialVector(random, 80),
              acceleration:
                  acceleration?.call(random) ?? randomRadialVector(random, 40),
              child: childBuilder(i, random, 0),
            );
          },
        ),
      ),
    );
  }
}
