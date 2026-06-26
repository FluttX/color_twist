import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:color_twist/features/gameplay/game/components/player.dart';
import 'package:color_twist/features/gameplay/game/components/pooled_collision_reset.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent
    with
        CollisionCallbacks,
        HasGameReference<TwistColorGame>,
        PooledCollisionReset {
  StarComponent({required super.position})
      : super(size: Vector2(28, 28), anchor: Anchor.center, priority: 15);

  StarComponent.initial() : this(position: Vector2.zero());

  Sprite? _starSprite;
  bool _spriteLoaded = false;
  bool _hitboxAdded = false;
  bool _collected = false;

  bool get isCollected => _collected;

  void prepareForReuse({required Vector2 position}) {
    resetPooledCollisions();
    this.position = Vector2(0, position.y);
    _collected = false;
    _hitboxAdded = false;
    _ensureHitbox();
  }

  void prepareForPool() {
    resetPooledCollisions();
    _collected = false;
  }

  void markCollected() {
    _collected = true;
  }

  @override
  Future<void> onLoad() async {
    _ensureHitbox();
    if (!_spriteLoaded) {
      _starSprite = await Sprite.load(AssetPaths.starIcon);
      _spriteLoaded = true;
    }
    await super.onLoad();
  }

  @override
  void onMount() {
    super.onMount();
    _collected = false;
    _ensureHitbox();
  }

  void _ensureHitbox() {
    if (_hitboxAdded) return;
    add(CircleHitbox(
      radius: size.x / 2 + 4,
      collisionType: CollisionType.passive,
    ));
    _hitboxAdded = true;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    _tryCollect(other);
  }

  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);
    _tryCollect(other);
  }

  void _tryCollect(PositionComponent other) {
    if (_collected || !isMounted) return;
    if (!_isPlayer(other)) return;
    game.collectStar(this);
  }

  bool _isPlayer(PositionComponent other) {
    if (other is Player) return true;
    return other.parent is Player;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_starSprite == null) return;
    _starSprite!.render(
      canvas,
      size: size,
      position: size / 2,
      anchor: Anchor.center,
    );
  }
}
