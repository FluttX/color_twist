import 'package:color_twist/features/gameplay/game/components/circle_rotator.dart';
import 'package:color_twist/features/gameplay/game/components/color_switcher.dart';
import 'package:color_twist/features/gameplay/game/components/star_component.dart';
import 'package:color_twist/features/gameplay/game/generation/component_pool.dart';
import 'package:color_twist/features/gameplay/models/level_object.dart';
import 'package:flame/components.dart';

class ObstacleFactory {
  ObstacleFactory()
      : _circlePool = ObstacleComponentPool(() => CircleRotator.initial()),
        _starPool = ObstacleComponentPool(() => StarComponent.initial()),
        _switcherPool = ObstacleComponentPool(() => ColorSwitcher.initial());

  final ObstacleComponentPool<CircleRotator> _circlePool;
  final ObstacleComponentPool<StarComponent> _starPool;
  final ObstacleComponentPool<ColorSwitcher> _switcherPool;

  PositionComponent spawn(LevelObject object) {
    return switch (object.type) {
      LevelObjectType.colorSwitcher => _spawnSwitcher(object),
      LevelObjectType.star => _spawnStar(object),
      LevelObjectType.circleRotator => _spawnCircle(object),
    };
  }

  void release(PositionComponent component) {
    switch (component) {
      case final CircleRotator circle:
        circle.prepareForPool();
        if (circle.isMounted) circle.removeFromParent();
        _circlePool.release(circle);
      case final StarComponent star:
        star.prepareForPool();
        if (star.isMounted) star.removeFromParent();
        _starPool.release(star);
      case final ColorSwitcher switcher:
        switcher.prepareForPool();
        if (switcher.isMounted) switcher.removeFromParent();
        _switcherPool.release(switcher);
      default:
        if (component.isMounted) component.removeFromParent();
    }
  }

  ColorSwitcher _spawnSwitcher(LevelObject object) {
    final switcher = _switcherPool.acquire();
    switcher.prepareForReuse(position: Vector2(object.positionX, object.positionY));
    return switcher;
  }
  StarComponent _spawnStar(LevelObject object) {
    final star = _starPool.acquire();
    star.prepareForReuse(position: Vector2(object.positionX, object.positionY));
    return star;
  }

  CircleRotator _spawnCircle(LevelObject object) {
    final circle = _circlePool.acquire();
    circle.prepareForReuse(
      position: Vector2(object.positionX, object.positionY),
      size: Vector2.all(object.size ?? 180),
      rotationSpeed: object.rotationSpeed ?? 1.2,
      initialAngle: object.initialAngle ?? 0,
      moveAmplitudeX: object.moveAmplitudeX ?? 0,
      moveAmplitudeY: object.moveAmplitudeY ?? 0,
      moveSpeed: object.moveSpeed ?? 0,
    );
    return circle;
  }
}
