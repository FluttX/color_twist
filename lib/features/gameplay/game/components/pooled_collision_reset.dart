import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

/// Clears stale Flame collision state when reusing pooled components.
mixin PooledCollisionReset on PositionComponent {
  void resetPooledCollisions() {
    if (this is CollisionCallbacks) {
      final callbacks = this as CollisionCallbacks;
      for (final other in callbacks.activeCollisions.toList()) {
        callbacks.onCollisionEnd(other);
      }
    }

    for (final hitbox in children.whereType<ShapeHitbox>().toList()) {
      for (final other in hitbox.activeCollisions.toList()) {
        hitbox.onCollisionEnd(other);
      }
      hitbox.removeFromParent();
    }
  }
}
