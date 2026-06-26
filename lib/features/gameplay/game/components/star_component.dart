import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:color_twist/features/gameplay/game/twist_color_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class StarComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<TwistColorGame> {
  StarComponent({required super.position})
      : super(size: Vector2(28, 28), anchor: Anchor.center);

  late Sprite _starSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _starSprite = await Sprite.load(AssetPaths.starIcon);

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
    game.particleEffects.playStarCollect(position);
    removeFromParent();
  }
}
