import 'package:color_twist/core/constants/asset_paths.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  Ground({required super.position})
      : super(
          size: Vector2(200, 2),
          anchor: Anchor.center,
        );

  late Sprite fingerSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    fingerSprite = await Sprite.load(AssetPaths.fingerTap);
  }

  @override
  void render(Canvas canvas) {
    fingerSprite.render(
      canvas,
      size: Vector2(100, 100),
      position: Vector2(56, 0),
    );
  }
}
