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
    this.rotationSpeed,
    this.initialAngle,
    this.moveAmplitudeX,
    this.moveAmplitudeY,
    this.moveSpeed,
  });

  final LevelObjectType type;
  final double positionX;
  final double positionY;
  final double? size;
  final double? rotationSpeed;
  final double? initialAngle;
  final double? moveAmplitudeX;
  final double? moveAmplitudeY;
  final double? moveSpeed;

  LevelObject copyWith({
    LevelObjectType? type,
    double? positionX,
    double? positionY,
    double? size,
    double? rotationSpeed,
    double? initialAngle,
    double? moveAmplitudeX,
    double? moveAmplitudeY,
    double? moveSpeed,
  }) {
    return LevelObject(
      type: type ?? this.type,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      size: size ?? this.size,
      rotationSpeed: rotationSpeed ?? this.rotationSpeed,
      initialAngle: initialAngle ?? this.initialAngle,
      moveAmplitudeX: moveAmplitudeX ?? this.moveAmplitudeX,
      moveAmplitudeY: moveAmplitudeY ?? this.moveAmplitudeY,
      moveSpeed: moveSpeed ?? this.moveSpeed,
    );
  }
}
