import 'package:color_twist/features/gameplay/models/level_object.dart';

class LevelDefinition {
  const LevelDefinition({
    required this.id,
    required this.objects,
    this.groundY = 400,
    this.playerY = 300,
  });

  final String id;
  final List<LevelObject> objects;
  final double groundY;
  final double playerY;
}
