class DifficultySnapshot {
  const DifficultySnapshot({
    required this.rotationSpeed,
    required this.minSpacing,
    required this.maxSpacing,
    required this.starWeight,
    required this.switcherWeight,
    required this.singleCircleWeight,
    required this.doubleCircleWeight,
    required this.specialPatternWeight,
    required this.horizontalMoveChance,
    required this.verticalMoveChance,
    required this.moveAmplitude,
    required this.moveSpeed,
    required this.gravity,
    required this.jumpSpeed,
  });

  final double rotationSpeed;
  final double minSpacing;
  final double maxSpacing;
  final double starWeight;
  final double switcherWeight;
  final double singleCircleWeight;
  final double doubleCircleWeight;
  final double specialPatternWeight;
  final double horizontalMoveChance;
  final double verticalMoveChance;
  final double moveAmplitude;
  final double moveSpeed;
  final double gravity;
  final double jumpSpeed;
}
