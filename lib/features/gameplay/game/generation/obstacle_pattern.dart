import 'package:color_twist/features/gameplay/models/level_object.dart';

enum PatternId {
  switcherCircle,
  starCircle,
  circleStar,
  doubleCircle,
  switcherDoubleCircle,
  movingCircle,
}

class ObstaclePattern {
  const ObstaclePattern({
    required this.id,
    required this.objects,
    required this.height,
    required this.minScore,
  });

  final PatternId id;
  final List<LevelObject> objects;
  final double height;
  final int minScore;
}
