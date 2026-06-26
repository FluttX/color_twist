import 'package:color_twist/features/gameplay/game/components/circle_rotator.dart';
import 'package:color_twist/features/gameplay/game/components/color_switcher.dart';
import 'package:color_twist/features/gameplay/game/components/star_component.dart';
import 'package:color_twist/features/gameplay/models/level_definition.dart';
import 'package:color_twist/features/gameplay/models/level_object.dart';
import 'package:flame/components.dart';

class LevelLoader {
  const LevelLoader();
  void loadInto(World world, LevelDefinition level) {
    for (final object in level.objects) {
      world.add(_createComponent(object));
    }
  }

  Component _createComponent(LevelObject object) {
    final position = Vector2(object.positionX, object.positionY);

    return switch (object.type) {
      LevelObjectType.colorSwitcher => ColorSwitcher(position: position),
      LevelObjectType.star => StarComponent(position: position),
      LevelObjectType.circleRotator => CircleRotator(
          position: position,
          size: Vector2.all(object.size!),
        ),
    };
  }
}
