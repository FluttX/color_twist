import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent with CollisionCallbacks {
  StarComponent({required super.position})
      : super(size: Vector2(28, 28), anchor: Anchor.center);

  late Sprite _starSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _starSprite = await Sprite.load('star_icon.png');

    /// ADD HIT-BOX FOR COLLISION
    add(CircleHitbox(radius: size.x / 2, collisionType: CollisionType.passive));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _starSprite.render(
      canvas,
      size: size,
      position: size / 2,
      anchor: Anchor.center,
    );
  }

  void showCollectEffect() {
    final rnd = Random();
    Vector2 randomVector() => (Vector2.random(rnd) - Vector2.random(rnd)) * 80;
    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 0.8,
          generator: (i) {
            return AcceleratedParticle(
              speed: randomVector(),
              acceleration: randomVector(),
              child: RotatingParticle(
                to: rnd.nextDouble() * pi * 2,
                child: ComputedParticle(
                  renderer: (canvas, particle) {
                    _starSprite.render(
                      canvas,
                      size: size * (1 - particle.progress),
                      anchor: Anchor.center,
                      overridePaint: Paint()
                        ..color = Colors.white.withOpacity(
                          1 - particle.progress,
                        ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );

    removeFromParent();
  }
}
