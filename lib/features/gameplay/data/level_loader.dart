import 'package:color_twist/features/gameplay/game/generation/obstacle_factory.dart';
import 'package:color_twist/features/gameplay/models/level_definition.dart';
import 'package:flame/components.dart';

class LevelLoader {
  const LevelLoader({this.obstacleFactory});

  final ObstacleFactory? obstacleFactory;

  void loadInto(
    World world,
    LevelDefinition level, {
    ObstacleFactory? obstacleFactory,
  }) {
    final factory = obstacleFactory ?? this.obstacleFactory ?? ObstacleFactory();
    for (final object in level.objects) {
      world.add(factory.spawn(object));
    }
  }
}
