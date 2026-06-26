enum LevelObjectType {
  colorSwitcher,
  star,
  circleRotator,
}

class LevelObject {
  const LevelObject({
    required this.type,
    required this.positionX,
    required this.positionY,
    this.size,
  });

  final LevelObjectType type;
  final double positionX;
  final double positionY;
  final double? size;
}
